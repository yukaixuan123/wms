import Vue from 'vue'
import App from './App.vue'
import ElementUI from 'element-ui';
import router from './router/index.js';
import store from './store/index.js';



import 'element-ui/lib/theme-chalk/index.css';
Vue.use(ElementUI);




new Vue({
  render: h => h(App),
  router,
  store
}).$mount('#app')
