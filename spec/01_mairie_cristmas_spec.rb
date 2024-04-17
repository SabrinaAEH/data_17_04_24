require_relative '../lib/01_mairie_cristmas.rb'

describe "the townhall_list function" do
    describe "Basic functionality" do
      it "does not return an empty result" do
        expect(get_townhall_emails).not_to eq (' ')
      end
      it "does not return an error" do
        expect(get_townhall_emails).not_to eq (nil)
      end
      it "does not give you a list over 100 results" do
        expect(get_townhall_emails.length).to be <= 100
      end
    end
end  