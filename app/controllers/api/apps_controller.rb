module Api
  class AppsController < ApplicationController
    skip_before_action :verify_authenticity_token

    #api to get all applications
    def getApps
      apps = App.order('created_at DESC')
      render json: {status: 'SUCCESS' , data: apps } , status: :ok
    end

    #api to get single application by its token
    def getAppById
      app = App.find_by(access_token: params[:access_token])
      render json: {status: 'SUCCESS' , data: app } , status: :ok
    end

    #api to create new application and return its token
    def createApp
      params.require(:name)
      app = App.create(name: params[:name])
      if !app.nil?
        render json: {status: 'SUCCESS' , data: app } , status: :ok
      else
        render json: {status: 'ERROR' , data: app.errors} , status: :unprocessable_entity
      end
    end

    #api to update application name by its token
    def updateApp
      params.require(:name)

      app = App.find_by(access_token: params[:access_token])
      if app.update(name: params[:name])
        render json: {status: 'SUCCESS' , data: app } , status: :ok
      else
        render json: {status: 'ERROR' , data: app.errors } , status: :unprocessable_entity
      end
    end

  end
end