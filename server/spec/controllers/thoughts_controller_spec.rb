describe ThoughtsController do
  let(:salt) { SecureRandom.uuid }
  let(:username) { 'jeff' }
  let(:password) { 'pass' }
  let(:user) { User.create!(username: username, salt: salt, password: salt + password) }
  let!(:jwt_token) { AuthenticateUser.call(user.username, password, user.salt).result }
  
  context '#index' do
    context 'unauthenticated user' do
      it 'gets an unauthorized response' do
        get :index
        expect(response.status).to eq(401)
      end
    end
    
    context 'authenticated user' do
      before do
        20.times { create(:thought, user: user) }
      end
      
      it 'can get a list of thoughts' do
        request.headers['Authorization'] = jwt_token
        get :index, format: :json
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        last_thoughts = Thought.order(updated_at: :desc).limit(10).map(&:api_response_json)
        expect(body).to eq(last_thoughts)
      end
      
      it 'can set the limit of how many thoughts to get' do
        request.headers['Authorization'] = jwt_token
        get :index, format: :json, params: { limit: 5 }
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body.length).to eq(5)
      end
      
      it 'can request with a filter' do
        thought1 = create(:thought, user: user, text: 'Scrambled eggs and cheddar cheese for breakfast')
        thought2 = create(:thought, user: user, text: 'Gruyere cheese for lunch')

        request.headers['Authorization'] = jwt_token
        get :index, format: :json, params: { filter: 'cheese' }
        body = JSON.parse(response.body)
        expect(body).to eq([thought1, thought2].map(&:api_response_json))
      end
    end
  end
  
  context '#create' do
    it 'can create a new user' do
      post :create, format: :json, params: { username: 'boris', password: 'moo'}
      
      body = JSON.parse(response.body)
      
      expect(response.status).to eq(201)
      expect(User.count).to eq(1)
      expect(User.first.username).to eq('boris')
      
      expect(body.keys).to eq(['auth_token'])
      expect(body['auth_token']).not_to be_nil
    end
  end
end
