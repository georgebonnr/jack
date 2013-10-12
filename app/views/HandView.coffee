
# view of collection of card
class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2>
  <% if(isDealer){ %>Dealer<% }
  else{ %>You<% } %> (<span class="score"></span>)
 <% if (isDealer) {
      if (scores().length > 1) {
        if (!((models[0].attributes.value === 1) && (models[0].attributes.revealed === false))) {
          %>(<span class="score2"></span>)<%
        }
      }
    } else {
      if (scores().length > 1) { %>
        (<span class="score2"></span>) <%
      }
    }
    %> </h2>'


  initialize: ->
    @collection.on 'add remove change', =>
      @render()
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
      # GEORGE: Implement logic here to choose whether to display ace score or not??
    @$('.score').text @collection.scores()[0]
    @$('.score2').text @collection.scores()[1]


# <h2>
#   <% if(isDealer){ %>Dealer<% }
#   else{ %>You<% } %> (<span class="score"></span>)
#  <% if (dealerScore().length > 1) {
#       if (isDealer) {
#       if (models[0].attributes.value !== 1) {%>
#       (<span class="score2"></span>) <%
#       }
#       }
#       else  { %>
#       (<span class="score2"></span>) <%
#       }
#     }%> </h2>'



# template: _.template '<h2>
#   <% if(isDealer){ %>Dealer<% }
#   else{ %>You<% } %> (<span class="score"></span>)
#  <% if (isDealer) {
#       if (scores().length > 1) {
#         var hiddenAce = ((models[0].attributes.value === 1) && (models[0].get("revealed") === undefined)
#         if (!hiddenAce) {
#           %>(<span class="score2"></span>)<%
#         }
#       }
#     } else {
#       if (scores().length > 1) { %>
#         (<span class="score2"></span>) <%
#       }
#     }
#     %> </h2>'