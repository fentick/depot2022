class LineItemsController < ApplicationController
  include CurrentCart
  include StoreIndexCount

  before_action :set_cart, only: [:create, :reduce]

  before_action :set_line_item, only: %i[ show edit update reduce destroy ]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_line_item
  
  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    # chp 9:    @line_item = @cart.line_item.build(product: product)

   respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item = @line_item }
        # chp 11: F1
        # format.turbo_stream do
        #   render turbo_stream: turbo_stream.replace(
        #     :cart,
        #     partial: 'layouts/cart',
        #     locals: { cart: @cart }
        #   )
        # end

        format.html { redirect_to store_index_url }        

        store_index_reset

        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to line_item_url(@line_item), notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST
  def reduce
    product = Product.find(params[:product_id])
    if @line_item.quantity > 1
      @line_item = @cart.reduce_product(product)

      respond_to do |format|
        if @line_item.save
          format.turbo_stream { @current_item = @line_item }
          format.html { redirect_to store_index_url }
          format.json { render :show, status: :ok, location: @line_item }
        else
          format.html { redirect_to store_index_url }
          format.json { render json: @line_item.errors, status: :unprocessable_entity }
        end
      end

    elsif @line_item.quantity = 1
      @line_item.destroy

      respond_to do |format|
        format.html { redirect_to store_index_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to store_index_url }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

    def invalid_line_item
      redirect_to store_index_url, notice: 'The link is Invalid.'
    end
end
