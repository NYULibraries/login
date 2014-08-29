require 'spec_helper'
module Login
  module Aleph
    module FlatFile
      describe FlatFileLoader do
        context "when flatfile exists" do
          let(:location) { ENV["FLAT_FILE"]  }
          let(:flatfile) { FlatFileLoader.new(location)}
          let(:identifier) { "BOR_ID" }
          describe "#find_line_by_identity" do
            subject { flatfile.find_line_by_identity(identifier) }
            it { should be_a FlatFileLine }
            its(:identifier) { should eql identifier }
          end
        end
        context "when flatfile doesn't exists" do
          let(:location) { "" }
          let(:flatfile) { FlatFileLoader.new(location)}
          let(:identifier) { "BOR_ID" }
          describe "#find_line_by_identity" do
            subject { flatfile.find_line_by_identity(identifier) }
            it "should raise an error" do
               expect { subject }.to raise_error(Errno::ENOENT)
            end
          end
        end
      end
    end
  end
end
