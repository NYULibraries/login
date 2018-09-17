require 'rails_helper'
module Login
  module Aleph
    describe FlatFile::FlatFileLine do
      let(:flatfileline) { FlatFile::FlatFileLine.new(line) }
      context "when flatfile line exists" do
        context "and the flatfile line is complete" do
          let(:line) { "BOR_ID\t12345678910112\tencrypted_value\t20140101\t03\t0\tELOPER,DEV\tdeveloper@nyu.edu\tY\tPLIF STATUS\tCC\tCOLLEGE\t00\tDEPARTMENT\t00000\tMAJOR\tILL LIBRARY\n" }
          describe "#matches_identifier?" do
            subject { flatfileline.matches_identifier?('12345678910112') }
            it { is_expected.to be true }
          end
          describe "#identifier" do
            subject { flatfileline.identifier }
            it { should eq "BOR_ID" }
          end
          describe "#barcode" do
            subject { flatfileline.barcode }
            it { should eq "12345678910112" }
          end
          describe "#verification" do
            subject { flatfileline.verification }
            it { should eq "encrypted_value" }
          end
          describe "#expiry_date" do
            subject { flatfileline.expiry_date }
            it { should eq "20140101" }
          end
          describe "#patron_status" do
            subject { flatfileline.patron_status }
            it { should eq "03" }
          end
          describe "#patron_type" do
            subject { flatfileline.patron_type }
            it { should be_nil }
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
            it { should eq "PLIF STATUS" }
          end
          describe "#college_code" do
            subject { flatfileline.college_code }
            it { should eq "CC" }
          end
          describe "#college" do
            subject { flatfileline.college }
            it { should eq "COLLEGE" }
          end
          describe "#dept_code" do
            subject { flatfileline.dept_code }
            it { should eq "00" }
          end
          describe "#department" do
            subject { flatfileline.department }
            it { should eq "DEPARTMENT" }
          end
          describe "#major_code" do
            subject { flatfileline.major_code }
            it { should eq "00000" }
          end
          describe "#major" do
            subject { flatfileline.major }
            it { should eq "MAJOR" }
          end
          describe "#ill_library" do
            subject { flatfileline.ill_library }
            it { should eq "ILL LIBRARY" }
          end
          describe "#to_patron" do
            subject { flatfileline.to_patron }
            it { should be_a Patron }
          end
        end
        context "and the flatfile line isn't complete" do
          let(:line) { "BOR_ID	12345678910112	encrypted_value	20140101	03	0	ELOPER,DEV	developer@nyu.edu	Y" }
          describe "#identifier" do
            subject { flatfileline.identifier }
            it { should eq "BOR_ID" }
          end
          describe "#barcode" do
            subject { flatfileline.barcode }
            it { should eq "12345678910112" }
          end
          describe "#verification" do
            subject { flatfileline.verification }
            it { should eq "encrypted_value" }
          end
          describe "#expiry_date" do
            subject { flatfileline.expiry_date }
            it { should eq "20140101" }
          end
          describe "#patron_status" do
            subject { flatfileline.patron_status }
            it { should eq "03" }
          end
          describe "#patron_type" do
            subject { flatfileline.patron_type }
            it { should be_nil }
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
        describe "#matches_identifier?" do
          subject { flatfileline.matches_identifier?('12345678910112') }
          it { is_expected.to be false }
        end
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
        describe "#patron_status" do
          subject { flatfileline.patron_status }
          it { should be_nil }
        end
        describe "#patron_type" do
          subject { flatfileline.patron_type }
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
          it 'should throw argument error when missing bor_name' do
            expect { flatfileline.to_patron }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
