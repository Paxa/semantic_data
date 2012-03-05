require "bacon"

$LOAD_PATH << File.dirname(File.expand_path(__FILE__)) + '/../lib'

require "linker"

describe 'Linker.extract' do
  def pass_1(str, domain = nil)
    Linker.extract(str, domain || "http://example.com").first
  end
  
  it "should parse quoted attribute" do
    pass_1(%{<a href="http://example.com">}).should == "http://example.com"
    pass_1(%{<a href='http://example.com'>}).should == "http://example.com"
  end
  
  it "should parse unquoted" do
    pass_1(%{<a href=http://example.com>}).should == "http://example.com"
  end
  
  it "should parse with whitespaces" do
    pass_1(%{<a href = "http://example.com">}).should == "http://example.com"
    pass_1(%{<a href\n\n=\n\n"http://example.com">}).should == "http://example.com"
    pass_1(%{<a href\t\n=\t\r\n"http://example.com">}).should == "http://example.com"
  end
  
  it "should not parse unclosed link" do
    pass_1(%{<a href="http://example.com" href="dada" <a href = "">}).should == "http://example.com"
  end
  
  it "should parse empty link" do
    pass_1(%{<a href="">}).should == nil
    pass_1(%{<a href=>}).should == nil
    pass_1(%{<a href>}).should == nil
  end
  
  it "should make absolute with domain from absolute to domain" do
    pass_1(%{<a href="/about_my_wife">}).should == "http://example.com/about_my_wife"
  end
  
  it "should parse domain string correctly" do
    pass_1(%{<a href = "/about_my_wife">}, "http://example.com/dadada/bebebe").should == "http://example.com/about_my_wife"
  end
  
  it "should parse simple relative paths" do
    pass_1(%{<a href="/about_my_wife">}).should == "http://example.com/about_my_wife"
  end
  
  it "should cut # and after" do
    pass_1(%{<a href="/about#dadada">}).should == "http://example.com/about"
  end
  
  it "should skip # - links" do
    pass_1(%{<a href="#dadada">}).should == nil
  end
  
  it "should calulate and skip duplicate with current" do
    pass_1(%{<a href="/about#dadada">}, "http://example.com/about").should == nil
  end
  
  it "should calculate dir level with ./" do
    pass_1(%{<a href="./about">}).should == "http://example.com/about"
    pass_1(%{<a href="./about">}, "http://example.com/tube").should == "http://example.com/about"
  end
  
  it "should calculate dir level with ../" do
    pass_1(%{<a href="../about">}, "http://example.com/tube/").should == "http://example.com/about"
    pass_1(%{<a href="../about">}, "http://example.com/").should == "http://example.com/about"
    pass_1(%{<a href="../../about">}, "http://example.com/info/p/a/file.txt").should == "http://example.com/info/about"
  end
  
  it "should skip mailto: links" do
    pass_1(%{<a href="mailto:dada@dada.com">}).should == nil
  end
  
  it "should skip javascript: links" do
    pass_1(%{<a href="javascript::void(0)">}).should == nil
  end
  
  it "should parse relative link" do
    link = pass_1(%{<a href="exhibition-2005.html">}, 'http://vmimages.net/welcome.html')
    p link
    link.should == "http://vmimages.net/exhibition-2005.html"
  end
end