describe "the search process", type: :feature do
  it "test for search member by name" do
    date = DateTime.now.to_date - 50.year
    member_1 = TribeMember.create!(name: "John", surname: "Luck", birthdate: date, latitude: 41.808907, longitude: -87.684659)
    visit '/tribe_members'
    fill_in('name', with: 'John')
    click_button('search_by_name')
    expect(page).to have_text('John')
    expect(page).to have_text('Luck')
  end

  it "test for search member by surname" do
    date = DateTime.now.to_date - 50.year
    member_1 = TribeMember.create!(name: "Luck", surname: "surname", birthdate: date, latitude: 41.808907, longitude: -87.684659)
    visit '/tribe_members'
    fill_in('surname', with: 'surname')
    click_button('search_by_surname')
    expect(page).to have_text('Luck')
    expect(page).to have_text('surname')
  end

  it "test for search member by birthdate" do
    date = "2000/12/03".to_date
    member_1 = TribeMember.create!(name: "Henry", surname: "birthdate", birthdate: date, latitude: 41.808907, longitude: -87.684659)
    visit '/tribe_members'
    select '2000', :from => 'member_birthdate_birthdate_1i'
    select 'December', :from => 'member_birthdate_birthdate_2i'
    select '3', :from => 'member_birthdate_birthdate_3i'
    click_button('search_by_birthdate')
    expect(page).to have_text('Henry')
    expect(page).to have_text('birthdate')
  end

  it "test for search member by ancestor" do
    date_1 = DateTime.now.to_date - 50.year
    date_2 = DateTime.now.to_date - 100.year
    member_1 = TribeMember.create!(name: "Thierry", surname: "ancestor", birthdate: date_1, latitude: 41.808907, longitude: -87.684659)
    member_2 = TribeMember.create!(name: "John", surname: "children", birthdate: date_2, latitude: 41.808907, longitude: -87.684659, ancestor: member_1)
    visit '/tribe_members'
    fill_in('ancestor_name', with: 'Thierry')
    fill_in('ancestor_surname', with: 'ancestor')
    click_button('search_by_ancestor_name')
    expect(page).to have_text('John')
    expect(page).to have_text('children')
  end
end
