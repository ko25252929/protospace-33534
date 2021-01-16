class PrototypesController < ApplicationController
    before_action :set_prototype, only: [:show]
    before_action :move_to_index, except: [:index, :shwo]
    before_action :authenticate_user!, except: [:index, :show]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end
  
  def update
    @prototype = Prototype.find(params[:id]) 
    if @prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
       redirect_to root_path
    else
       render :new
    end
  end

  def destroy
      prototype = Prototype.find(params[:id])
      prototype.destroy
      redirect_to root_path
  end 
  
  
  
  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  
  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
   end
  end 
end
