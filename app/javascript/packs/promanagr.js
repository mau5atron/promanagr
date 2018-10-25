import Vue from 'vue/dist/vue.esm'

import VueResource from 'vue-resource'

Vue.use(VueResource)

document.addEventListener('turbolinks:load', () => {
	Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  let element = document.getElementById('team-form')

  if(element != null){
  	let id = element.dataset.id
  	let team = JSON.parse(element.dataset.team)
  	let users_attributes = JSON.parse(element.dataset.userAttributes)
  	users_attributes.forEach(function(user){
  		user._destroy = null; 
  	});

  	team.users_attributes = users_attributes


  	const app = new Vue({
  		el: element,
  		data: function(){
  			return {
  				id: id,
  				team: team,
  				errors: [],
  				scrollPosition: null
  			}
  		},


  		mounted(){
  			// as app initializes, this runs 
  			window.addEventListener('scroll', this.updateScroll)
  		},

  		methods: {
  			updateScroll(){
  				this.scrollPosition = window.scrollY
  			},

  			addUser: function(){
  				// when a user is added - new user form fields will be blank 
  				this.team.users_attributes.push({
  					id: null,
  					name: "",
  					email: "",
  					_destroy: null
  				})
  			},

  			removeUser: function(index){
  				const user = this.team.users_attributes[index]

  				if(user.id == null){
						this.team.users_attributes.splice(index, 1)
  				} else {
  					this.team.users_attributes[index]._destroy = "1"
  				}
  			},

  			undoRemove: function(index){
					this.team.users_attributes[index]._destroy = null 
  			},

  			saveTeam: function(){
  				if(this.id == null){
  					this.$http.post('/teams', { team: this.team }).then(response => {
  						Turbolinks.visit(`/teams/${response.body.id}`)
  					}, response => {
  						// if there is an error with the response then display an error with a log of the error 
  						console.log(response)

  						if(response.status = 422){
  							let json = JSON.parse(response.bodyText);
  							this.errors = json['user.email'][0]
  						}

  					})
  				} else {
  					// edit an existing team 
  					this.$http.put(`/teams/${this.id}`, { team: this.team }).then(response => {
  						Turbolinks.visit(`/teams/${response.body.id}`)
  					}, response => {
  						console.log(response)
  					})
  				}
  			},

  			existingTeam: function(){
  				return this.team.id != null
  			}
  		}
  	})
  } 

})