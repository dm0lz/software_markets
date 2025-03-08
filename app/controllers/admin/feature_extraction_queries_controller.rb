module Admin
  class FeatureExtractionQueriesController < ApplicationController
    before_action :set_feature_extraction_query, only: %i[ show edit update destroy ]

    # GET /feature_extraction_queries or /feature_extraction_queries.json
    def index
      @feature_extraction_queries = FeatureExtractionQuery.all
    end

    # GET /feature_extraction_queries/1 or /feature_extraction_queries/1.json
    def show
    end

    # GET /feature_extraction_queries/new
    def new
      @feature_extraction_query = FeatureExtractionQuery.new
    end

    # GET /feature_extraction_queries/1/edit
    def edit
    end

    # POST /feature_extraction_queries or /feature_extraction_queries.json
    def create
      @feature_extraction_query = FeatureExtractionQuery.new(feature_extraction_query_params)

      respond_to do |format|
        if @feature_extraction_query.save
          format.html { redirect_to [ :admin, @feature_extraction_query ], notice: "Feature extraction query was successfully created." }
          format.json { render :show, status: :created, location: @feature_extraction_query }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @feature_extraction_query.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /feature_extraction_queries/1 or /feature_extraction_queries/1.json
    def update
      respond_to do |format|
        if @feature_extraction_query.update(feature_extraction_query_params)
          format.html { redirect_to [ :admin, @feature_extraction_query ], notice: "Feature extraction query was successfully updated." }
          format.json { render :show, status: :ok, location: @feature_extraction_query }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @feature_extraction_query.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /feature_extraction_queries/1 or /feature_extraction_queries/1.json
    def destroy
      @feature_extraction_query.destroy!

      respond_to do |format|
        format.html { redirect_to admin_feature_extraction_queries_path, status: :see_other, notice: "Feature extraction query was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feature_extraction_query
        @feature_extraction_query = FeatureExtractionQuery.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def feature_extraction_query_params
        params.expect(feature_extraction_query: [ :content, :embedding, :search_field ])
      end
  end
end
