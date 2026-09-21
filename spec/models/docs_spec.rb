require 'rails_helper'

RSpec.describe Folder, type: :model do
  it "é válido com nome" do
    expect(build(:folder)).to be_valid
  end

  it "rejeita ciclo" do
    folder = create(:folder)
    child = create(:folder, user: folder.user, parent: folder)
    folder.parent = child
    expect(folder).not_to be_valid
  end

  it "rejeita pai de outro usuário" do
    folder = build(:folder, parent: create(:folder))
    expect(folder).not_to be_valid
  end
end

RSpec.describe Doc, type: :model do
  it "é válido com título" do
    expect(build(:doc)).to be_valid
  end

  it "renderiza markdown com sanitize" do
    doc = build(:doc, body: "# T\n\n<script>alert(1)</script>")
    html = doc.rendered_body
    expect(html).to include("<h1")
    expect(html).not_to include("<script>")
  end

  it ".search acha por título e corpo" do
    user = create(:user)
    found = create(:doc, user: user, title: "Roteiro", body: "nada")
    create(:doc, user: user, title: "Outro", body: "irrelevante")
    expect(Doc.search("roteiro")).to include(found)
  end
end
