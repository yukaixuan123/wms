// 定义基本的axios-baseaxios.js
import axios from 'axios'

const token = localStorage.getItem('token'); // 服务端拿的 token 可以从 vuex、localStorage 等地方取

axios.defaults.headers['authorization'] = `Bearer ${token}`;
// axios.create 创建一个axios实例  我们给这个实例编写配置，后续所有通过实例发送的请求，都受当前配置约束
const $http = axios.create({
    baseURL: '',
    timeout: 1000000,
    'token': localStorage.getItem('token')
});

// 添加请求拦截器
$http.interceptors.request.use(function (config) {
    // 在发送请求之前做些什么
    config.headers.token = '1'
    return config;
}, function (error) {
    // 对请求错误做些什么
    return Promise.reject(error);
});

// 添加响应拦截器
$http.interceptors.response.use(function (response) {
    let token = localStorage.getItem('token');
    // 对响应数据做点什么
    let data = response.data;

    return data;
}, function (error) {
    // 对响应错误做点什么
    return Promise.reject(error);
});
export default $http