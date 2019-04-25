class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get '/pets/new' do
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do
    @pet = Pet.create(name:params[:pet_name])
    if !params["owner_name"].empty?
      owner = Owner.create(name:params[:owner_name])
      owner.pets << @pet
    else
      owner = Owner.find_by_id(params[:pet_owner_ids])
      owner.pets << @pet
    end
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  get '/pets/:id/edit' do
    @pet = Pet.find(params[:id])
    @owners = Owner.all
    erb :'/pets/edit'
  end

  patch '/pets/:id' do
    ####### bug fix
    if !params[:pet].keys.include?("owner_id")
      params[:pet]["pet_id"] = []
    end
    #######
    @pet = Pet.find(params[:id])
    @pet.update(params["pet"])
    if !params["owner"]["name"].empty?
      @owner = Owner.create(params[:owner])
      @owner.pets << @pet
    end
    redirect to "pets/#{@pet.id}"
  end
end
