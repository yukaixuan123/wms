import vue from 'vue';
import vuex from 'vuex';
vue.use(vuex);



export default new vuex.Store({
    namespaced: true,
    state: {
        rightList: JSON.parse(sessionStorage.getItem('rightList') || '[]'),
        username: sessionStorage.getItem('username')

    },
    mutations: {
        setRightList(state, data) {
            state.rightList = data
            sessionStorage.setItem('rightList', JSON.stringify(data))
        },

    }, setUsername(state, data) {
        state.username = data
        sessionStorage.setItem('username', data)
    },
    actions: {
    },
    getters: {
    }
});