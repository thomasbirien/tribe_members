describe "the create process", type: :feature do
  # before :each do
  #   User.make(email: 'user@example.com', password: 'password')
  # end

  it "test for create member" do
    TribeMember.generate_stats
    visit '/tribe_members/new'
    fill_in('tribe_member_name', with: 'John')
    fill_in('tribe_member_surname', with: 'Loyc')
    select '1800', :from => 'tribe_member_birthdate_1i'
    select 'December', :from => 'tribe_member_birthdate_2i'
    select '2', :from => 'tribe_member_birthdate_3i'
    fill_in('tribe_member_latitude', with: '41.808907')
    fill_in('tribe_member_longitude', with: '-87.684659')
    fill_in('tribe_member_ancestor_name', with: 'John')
    fill_in('tribe_member_ancestor_surname', with: 'luck')
    click_button('Create member')
    # within("#session") do
    #   fill_in 'Email', with: 'user@example.com'
    #   fill_in 'Password', with: 'password'
    # end
    # click_button 'Sign in'
    expect(page).to have_current_path(tribe_members_path)
    # expect(TribeMember.last.name).to eq("John")
  end
end
