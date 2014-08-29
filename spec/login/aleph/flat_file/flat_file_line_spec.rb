require 'spec_helper'
module Login
  module Aleph
    module FlatFile
      describe FlatFileLine do
        context "when flatfile line exists" do
          let(:flatfile) { FlatFileLoader.new(ENV["FLAT_FILE"]) }
          context "and the flatfile line is complete" do
            let(:flatfileline) { flatfile.find_line_by_identity("N18158418") }
            describe "#identifier" do
              subject { flatfileline.identifier }
              it { should eq "N18158418" }
            end
            describe "#barcode" do
              subject { flatfileline.barcode }
              it { should eq "21142226710882" }
            end
            describe "#verification" do
              subject { flatfileline.verification }
              it { should eq "encrypted_value" }
            end
            describe "#expiry_date" do
              subject { flatfileline.expiry_date }
              it { should eq "20121031" }
            end
            describe "#status" do
              subject { flatfileline.status }
              it { should eq "65" }
            end
            describe "#type" do
              subject { flatfileline.type }
              it { should eq "0" }
            end
            describe "#bor_name" do
              subject { flatfileline.bor_name }
              it { should eq "ELOPER,DEV" }
            end
            describe "#email" do
              subject { flatfileline.email }
              it { should eq "developer@nyu.edu" }
            end
            describe "#ill_permission" do
              subject { flatfileline.ill_permission }
              it { should eq "Y" }
            end
            describe "#plif_status" do
              subject { flatfileline.plif_status }
              it { should eq "PLIF LOADED" }
            end
            describe "#college_code" do
              subject { flatfileline.college_code }
              it { should eq "LI" }
            end
            describe "#college" do
              subject { flatfileline.college }
              it { should eq "NYU Division of Libraries" }
            end
            describe "#dept_code" do
              subject { flatfileline.dept_code }
              it { should eq "01" }
            end
            describe "#department" do
              subject { flatfileline.department }
              it { should eq "DIVISION OF LIBRARIES" }
            end
            describe "#major_code" do
              subject { flatfileline.major_code }
              it { should eq "31300" }
            end
            describe "#major" do
              subject { flatfileline.major }
              it { should eq "INFO TECH SVCS/DIRCTR-DIG PROJ" }
            end
            describe "#ill_library" do
              subject { flatfileline.ill_library }
              it { should be_nil }
            end
            describe "#to_patron" do
              subject { flatfileline.to_patron }
              it { should be_a Patron }
            end
          end
          context "and the flatfile line isn't complete" do
            let(:flatfileline) { flatfile.find_line_by_identity("BOR_ID") }
            describe "#identifier" do
              subject { flatfileline.identifier }
              it { should eq "BOR_ID" }
            end
            describe "#barcode" do
              subject { flatfileline.barcode }
              it { should eq "21142226710882" }
            end
            describe "#verification" do
              subject { flatfileline.verification }
              it { should eq "encrypted_value" }
            end
            describe "#expiry_date" do
              subject { flatfileline.expiry_date }
              it { should eq "20121031" }
            end
            describe "#status" do
              subject { flatfileline.status }
              it { should eq "NYU Undergraduate Student" }
            end
            describe "#type" do
              subject { flatfileline.type }
              it { should eq "0" }
            end
            describe "#bor_name" do
              subject { flatfileline.bor_name }
              it { should eq "ELOPER,DEV" }
            end
            describe "#email" do
              subject { flatfileline.email }
              it { should eq "developer@nyu.edu" }
            end
            describe "#ill_permission" do
              subject { flatfileline.ill_permission }
              it { should eq "Y" }
            end
            describe "#plif_status" do
              subject { flatfileline.plif_status }
              it { should be_nil }
            end
            describe "#college_code" do
              subject { flatfileline.college_code }
              it { should be_nil }
            end
            describe "#college" do
              subject { flatfileline.college }
              it { should be_nil }
            end
            describe "#dept_code" do
              subject { flatfileline.dept_code }
              it { should be_nil }
            end
            describe "#department" do
              subject { flatfileline.department }
              it { should be_nil }
            end
            describe "#major_code" do
              subject { flatfileline.major_code }
              it { should be_nil }
            end
            describe "#major" do
              subject { flatfileline.major }
              it { should be_nil }
            end
            describe "#ill_library" do
              subject { flatfileline.ill_library }
              it { should be_nil }
            end
            describe "#to_patron" do
              subject { flatfileline.to_patron }
              it { should be_a Patron }
            end
          end
        end
        context "when flatfile line doesn't exists" do
          let(:line) { nil }
          let(:flatfileline) { FlatFileLine.new(line) }
          describe "#identifier" do
            subject { flatfileline.identifier }
            it { should be_nil }
          end
          describe "#barcode" do
            subject { flatfileline.barcode }
            it { should be_nil }
          end
          describe "#verification" do
            subject { flatfileline.verification }
            it { should be_nil }
          end
          describe "#expiry_date" do
            subject { flatfileline.expiry_date }
            it { should be_nil }
          end
          describe "#status" do
            subject { flatfileline.status }
            it { should be_nil }
          end
          describe "#type" do
            subject { flatfileline.type }
            it { should be_nil }
          end
          describe "#bor_name" do
            subject { flatfileline.bor_name }
            it { should be_nil }
          end
          describe "#email" do
            subject { flatfileline.email }
            it { should be_nil }
          end
          describe "#ill_permission" do
            subject { flatfileline.ill_permission }
            it { should be_nil }
          end
          describe "#plif_status" do
            subject { flatfileline.plif_status }
            it { should be_nil }
          end
          describe "#college_code" do
            subject { flatfileline.college_code }
            it { should be_nil }
          end
          describe "#college" do
            subject { flatfileline.college }
            it { should be_nil }
          end
          describe "#dept_code" do
            subject { flatfileline.dept_code }
            it { should be_nil }
          end
          describe "#department" do
            subject { flatfileline.department }
            it { should be_nil }
          end
          describe "#major_code" do
            subject { flatfileline.major_code }
            it { should be_nil }
          end
          describe "#major" do
            subject { flatfileline.major }
            it { should be_nil }
          end
          describe "#ill_library" do
            subject { flatfileline.ill_library }
            it { should be_nil }
          end
          describe "#to_patron" do
            subject { flatfileline.to_patron }
            it { should be_a Patron }
          end
        end
      end
    end
  end
end
