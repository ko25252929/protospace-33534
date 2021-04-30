class PrototypesController < ApplicationController
    before_action :set_prototype, except: [:index, :new, :create]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :contributor_confirmation, only: [:edit, :update, :destroy]

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
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
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


  def contributor_confirmation
    redirect_to root_path unless current_user == @prototype.user
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
   end
  end 
end
