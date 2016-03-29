require 'rails_helper'
module Login
  module Aleph
    describe FlatFile do
      context "when flatfile exists" do
        context "when flatfile is UTF-8 encoded" do
          let(:location) { "spec/data/patrons-UTF-8.dat"  }
          let(:flatfile) { FlatFile.new(location)}
          let(:identifier) { "identifier" }
          describe "#find_patron_by_identifier" do
            subject { flatfile.find_patron_by_identifier(identifier) }
            context 'when the user logged in with their identifier' do
              it { should be_a Patron }
              its(:identifier) { should eql identifier }
            end
            context 'when the user logged in with their barcode' do
              let(:identifier) { "barcode" }
              it { should be_a Patron }
              its(:identifier) { should eql "identifier" }
              its(:barcode) { should eql "barcode" }
            end
          end
          context "and then flatfile gets removed after loading" do
            describe "#find_patron_by_identifier" do
              before { flatfile.instance_variable_set(:@location, "") }
              subject { flatfile.find_patron_by_identifier(identifier) }
              it "should raise an error" do
                 expect { subject }.to raise_error(Errno::ENOENT)
              end
            end
          end
        end
        context "when flatfile is ISO-8859-1 encoded" do
          let(:location) { "spec/data/patrons-ISO-8859-1.dat"  }
          let(:encoding) { "ISO-8859-1"}
          let(:flatfile) { FlatFile.new(location, encoding)}
          let(:identifier) { "identifier" }
          describe "#find_patron_by_identifier" do
            subject { flatfile.find_patron_by_identifier(identifier) }
            it { should be_a Patron }
            its(:identifier) { should eql identifier }
          end
          context "and then flatfile gets removed after loading" do
            describe "#find_patron_by_identifier" do
              before { flatfile.instance_variable_set(:@location, "") }
              subject { flatfile.find_patron_by_identifier(identifier) }
              it "should raise an error" do
                 expect { subject }.to raise_error(Errno::ENOENT)
              end
            end
          end
        end
      end
      context "when flatfile doesn't exists" do
        let(:flatfile) { FlatFile.new(location)}
        let(:identifier) { "BOR_ID" }
        context "when location is nil" do
          let(:location) { nil }
          describe "#initalize" do
            subject { flatfile }
            it "should raise an error" do
               expect { subject }.to raise_error(ArgumentError)
            end
          end
        end
        context "when location is invalid" do
          let(:location) { "" }
          describe "#initalize" do
            subject { flatfile }
            it "should raise an error" do
               expect { subject }.to raise_error(ArgumentError)
            end
          end
        end
      end
    end
  end
end
