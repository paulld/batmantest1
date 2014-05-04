class Batmantest1.PostsController extends Batmantest1.ApplicationController
  routingKey: 'posts'

  index: (params) ->
    @set('posts', Batmantest1.Post.get('all'))

  show: (params) ->
    Batmantest1.Post.find params.id, @errorHandler (post) =>
      @set('post', post)

  edit: (params) ->

  new: (params) ->
    @set('post', new Batmantest1.Post)

  create: ->
    @post.save (err, post) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @redirect post

  update: (params) ->

  destroy: (node, event, context) ->
    post = if context.get('post') then context.get('post') else @post
    post.destroy (err) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        @redirect '/posts'
