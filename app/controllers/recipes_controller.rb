class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :its_invalid
    before_action :authorize

    def index
        recipes = Recipe.all
        render json: recipes
    end

    def create
        user = User.find_by(id: session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        if recipe
            render json: recipe, status: :created
        else
            render json: {errors: recipe.errors}, status: :unprocessable_entity
        end

    end

    private

    def authorize
        return render json: {errors: ["Not Authorized"]}, status: :unauthorized unless session.include? :user_id
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def its_invalid(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
