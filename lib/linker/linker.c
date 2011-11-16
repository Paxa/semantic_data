#include <ruby.h>

int compare_strings(char *s1, const char *s2, const int len) {
  int i;
  for(i = 0; i < len; i++) {
    if (s1[i] == '\0' || s1[i] != s2[i]) return 0;
  }
  return 1;
}

int str_size(char *s1) {
  int i = 0;
  while(s1[i] != '\0') i++;
  return i;
}

void skip_whitespace(char *s1, int *pos) {
  while (s1[*pos] == ' ' || s1[*pos] == '\n' || s1[*pos] == '\r' || s1[*pos] == '\t') {
    *pos += 1;
  }
}

int find_qu_char(char* s1, int* pos) {
  skip_whitespace(s1, pos);
  if (s1[*pos] == '=') {
    *pos += 1;
    return 1;
  } else {
    return 0;
  }
}

int domain_size(char *base_url) {
  double l = strlen(base_url);
  int i, protocol_gone = 0;
  
  for (i = 0; i < l; i++) {
    if (!protocol_gone && compare_strings(base_url + i, "://", 3)) {
      i += 3;
      protocol_gone = 1;
    }
    
    if (protocol_gone && base_url[i] == '/') return i;
  }
  return i;
}

void debug_string(char *s, int *len) {
  int i;
  
  printf("CUT ");
  for (i = 0; i < *len; i++) printf("%c", s[i]);
  printf("\n");
}

int move_upper_dir(char *base_url, int *len) {
  int i, d_size = domain_size(base_url);
  
  //printf("<> %d %d\n", d_size, *len - 1);
  if (base_url[*len - 1] == '/') *len -= 1;
  
  for (i = *len; i >= d_size - 1; i--) {
    if (base_url[i - 1] == '/') {
      *len = i - 1;
      break;
    }
  }
  return *len;
}

char* format_url(char *s1, int len, char *base_url) {
  char *attr;
  int d_size, csize, is_diff = 0, i;
  
  for (i = 0; i < len; i++) {
    if (s1[i] == '#') len = i;
  }

  if (len == 0) {
    return 0x0;
  } else if (compare_strings(s1, "http://", 7) || compare_strings(s1, "https://", 8)) {
    attr = (char *)malloc(len + 1);
    memmove(attr, s1, len);
    attr[len] = '\0';
  } else if (compare_strings(s1, "mailto:", 7) || compare_strings(s1, "javascript:", 11)){
    return 0x0;
  } else {
    if (s1[0] == '/') {
      d_size = domain_size(base_url);
    
      for (i = d_size; base_url[i] != '\0'; i++) {
        if (base_url[i] != s1[i - d_size]) is_diff = 1;
        if (!is_diff && i == d_size + len - 1) return 0x0;
      }
      
      while (compare_strings(s1, "../", 3)) {
        move_upper_dir(base_url, &d_size);
        s1 = s1 + 3;
        len -= 3;
      }
      
      attr = (char *)malloc(d_size + len + 1);
    } else {
      d_size = str_size(base_url);
      
      
      if (base_url[d_size - 1] != '/') {
        move_upper_dir(base_url, &d_size);
      }
      
      if (compare_strings(s1, "./", 2)) {
        s1 = s1 + 1;
        len -= 1;
      }
      
      if (compare_strings(s1, "../", 3)) {
        move_upper_dir(base_url, &d_size);
        s1 = s1 + 2;
        len -= 2;
      }
      
      while (compare_strings(s1, "/../", 4)) {
        move_upper_dir(base_url, &d_size);
        s1 = s1 + 3;
        len -= 3;
      }
      
      attr = (char *)malloc(d_size + len + 1);
    }
    
    memmove(attr, base_url, d_size);
    memmove(attr + d_size, s1, len);
    attr[d_size + len] = '\0';
  }
  return attr;
}

char* attr_string(char *s1, int *pos, char *base_url) {
  int is_quoted = 0, start_at = 0, finish_at = 0;
  
  skip_whitespace(s1, pos);
  
  if (s1[*pos] == '\'' || s1[*pos] == '"') {
    is_quoted = s1[*pos];
    *pos += 1;
    start_at = *pos;
    while (s1[*pos] != is_quoted && s1[*pos] != '\0') *pos += 1;
    finish_at = *pos;
  } else {
    start_at = *pos;
    while (s1[*pos] != ' ' && s1[*pos] != '\n' && s1[*pos] != '\t' && s1[*pos] != '\0' && s1[*pos] != '>') *pos += 1;
    finish_at = *pos;
  }
  
  return format_url(s1 + start_at, finish_at - start_at, base_url);
}

static VALUE linker_extract(VALUE self, VALUE data, VALUE r_base_url) {
  char* htmlData = RSTRING_PTR(data);
  char* base_url = RSTRING_PTR(r_base_url);
  VALUE links = rb_ary_new();

  int is_anchor = 0, attr_gone = 0;
  char* link;
  
  int i;
  
  for(i = 0; htmlData[i] != '\0'; i++) {
    if (!is_anchor && compare_strings(htmlData + i, "<a", 2)) {
      is_anchor = 1;
      i += 2;
    }
    if (is_anchor && htmlData[i] == '>') {
      is_anchor = 0;
      attr_gone = 0;
    }

    if (!attr_gone && is_anchor && compare_strings(htmlData + i, "href", 4)) {
      i += 4;
      if (find_qu_char(htmlData, &i)) {
        link = attr_string(htmlData, &i, base_url);
        if (link != 0x0) {
          rb_ary_push(links, rb_str_new2(link));
          free(link);
        }
        attr_gone = 1;
      }
    }
  }
  return links;
}

void Init_linker(void) {
  VALUE mLinker = rb_define_module("Linker");
  rb_define_singleton_method(mLinker, "extract", linker_extract, 2);
}