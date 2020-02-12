class UserController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def profile
    
        options ={}
        options[:include] = [:community_events]
        render json: { user: UserSerializer.new(current_user, options) }, status: :accepted
      
       
    end
!
    def index
        users = User.all 
        render json: users
    end 

    def show
        user = User.find(params[:id])
        render json: user
    end 

    def create 
        user = User.create(user_params)
      
        if user.valid?
            @token = encode_token(user_id: user.id)
            options ={}
             options[:include] = [:community_events]
            render json: { user: UserSerializer.new(user, options), jwt: @token }, status: :created
        else 
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end

    
    end 

    def update
        user = User.find(params[:id])
        user.update(user_params)
        if user.valid?
            render json: {user: UserSerializer.new(user)}
        else 
            render json: {error: 'this username has already been taken'}, status: :not_acceptable
        end 
    end 

    def destroy
        user = User.find(params[:id])
        user.destroy
        
    end 

    private 

    def user_params
        params.require(:user)
        .permit(:username, :name, :password, :password_confirmation)
    end 
end
