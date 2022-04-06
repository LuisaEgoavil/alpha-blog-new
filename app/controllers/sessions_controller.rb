# frozen_string_literal: true

# Managing the sessions for the users

class SessionsController < ApplicationController
  def new # rubocop:disable Style/EmptyMethod
  end

  def create
    # binding.break
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = 'Logged in successfully'
      redirect_to user

    else
      # Display as it happens, it doesn't request another http
      flash.now[:alert] = 'There was something wrong with your login details'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # binding.break
    session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to root_path
  end
end
