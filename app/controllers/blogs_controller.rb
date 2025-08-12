class BlogsController < ApplicationController
  before_action :required_login, only: [ :create, :update, :destroy ]

  def index
    @all_tags = Tag.pluck(:name)
    @all_authors = User.pluck(:name)

    @page = params[:page].to_i
    @page = 1 if @page < 1

    @limit = params[:limit].to_i
    @limit = 5 if @limit <= 0

    offset = (@page - 1) * @limit

    allowed_sort_columns = %w[title created_at]
    sort_by = allowed_sort_columns.include?(params[:sort_by]) ? params[:sort_by] : "created_at"
    sort_dir = params[:sort_dir].to_s.downcase == "asc" ? "asc" : "desc"

    search_query = params[:search].to_s.strip

    selected_authors = params[:authors] || []
    selected_tags = params[:tags] || []

    blogs_query = Blog.all

    blogs_query = blogs_query.where("title ILIKE ?", "%#{search_query}%") if search_query.present?

    if selected_authors.any?
      author_ids = User.where(name: selected_authors).pluck(:id)
      blogs_query = blogs_query.where(user_id: author_ids)
    end

    if selected_tags.any?
      blogs_query = blogs_query.joins(:tags).where(tags: { name: selected_tags }).distinct
    end

    @total_blogs = blogs_query.count
    @blogs = blogs_query.order("#{sort_by} #{sort_dir}").limit(@limit).offset(offset)
  end


  def show
    @blog = Blog.includes(:tags, :comments).find_by(id: params[:id])
    @comment = Comment.new
  end

  def edit
    @blog = Blog.find_by({ id: params[:id] })
  end

  def update
    @blog = Blog.find_by({ id: params[:id] })
    authorize @blog
    puts "updated blog >>>>>>>>>>>>>>>>>", @blog.inspect
    if @blog.update(blog_params)
      redirect_to @blog
    else
      flash[:notice] = "Erro while updating blog"
      redirect_back(fallback_location: root_path)
    end
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user

    if params[:blog][:tags_list].present?
      tag_names = params[:blog][:tags_list].split(",").map(&:strip)
      @blog.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
    end

    if @blog.save
      puts "Blog saved successfully!"
      redirect_to @blog, notice: "Blog was successfully created."
    else
      puts "Blog save failed: #{@blog.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @blog = Blog.find_by({ id: params[:id] })
    unless policy(@blog).destroy?
      flash[:notice] = "You cannot delete this post"
      return redirect_to @blog
    end
    if @blog.destroy
      redirect_to root_path
    else
      redirect_to @blog
    end
  end

  private

  def blog_params
    params.require(:blog).permit(:title, :excerpt, :content)
  end
end
