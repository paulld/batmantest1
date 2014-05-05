class Batmantest1.PostsController extends Batmantest1.ApplicationController
  routingKey: 'posts'

  @beforeAction 'fetchPost', only: ['show', 'edit']

  show: (params) ->
    # Initializing a new comment with the post_id given in params to display a corresponding form
    @set('comment', new Batmantest1.Comment(post_id: params.id))

  edit: (params) ->

  fetchPost: (params) ->
    Batmantest1.Post.find params.id, @errorHandler (post) =>
      @set('post', post)

  index: (params) ->
    @set('posts', Batmantest1.Post.get('all'))

  new: (params) ->
    @set('post', new Batmantest1.Post)

  create: ->
    @post.save (err, post) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @redirect post

  update: (params) ->
    @post.save (err, post) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @redirect post

  destroy: (node, event, context) ->
    post = if context.get('post') then context.get('post') else @post
    post.destroy (err) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @redirect '/posts'

# Specific to comments :

  destroyComment: (node, event, context) ->
    comment = context.get('comment')
    comment.destroy (err) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @post.get('comments').remove comment
        @redirect '/posts/' + @post.get('id')

  createComment: ->
    @comment.save =>
      # If everything goes well, we add the new comment to the current post's comments list so that it appears on the (html) page
      @post.get('comments').add @comment
      @redirect '/posts/' + @post.get('id')

