<template>
  <div id="hz1">
    <div class="z">
      <span style="float: left; margin-top: 20px; margin-left: 10px"
        ><img src="../Images/loho1.png" width="350" height="80px"
      /></span>
      <!--左边 -->
      <img class="s" src="../Images/loginLeft.png" width="800" height="475" />
      <a
        href="javascript:void(0)"
        style="
          font-size: 13px;
          color: #9031aa;
          position: absolute;
          bottom: 20px;
          right: 180px;
          text-decoration: none;
        "
        >CopyRight © 2023 ModernWMS 版权所有<br />
        <span style="color: #999999; text-decoration: none; padding-left: 58px"
          >闽ICP备2021008548号</span
        ></a
      >
    </div>
    <div class="y">
      <!--右边 -->
      <el-form
        :model="ruleForm"
        :rules="rules"
        ref="ruleForm"
        label-width="100px"
        class="demo-ruleForm"
      >
        <h3 style="margin-bottom: 30px; font-size: 19px">
          欢迎来到ModernWMS！<span>👋🏻</span>
        </h3>
        <el-form-item label="" prop="name" style="margin-left: -150px">
          <el-input
            v-model="ruleForm.name"
            id="text"
            placeholder="Username"
          ></el-input>
        </el-form-item>
        <el-form-item label="" prop="pwd" style="margin-left: -150px">
          <el-input
            v-model="ruleForm.pwd"
            show-password
            id="text"
            placeholder="Password"
          ></el-input>
        </el-form-item>
        <el-checkbox
          label="记住账号密码"
          checked="checked"
          name="type"
          style="margin-left: -48px; color: #999999"
        ></el-checkbox>
        <el-form-item>
          <el-button type="primary" @click="submitForm('ruleForm')" id="delu"
            >登录</el-button
          >
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>
<script>
import $http from "../http/base.js";
export default {
  data() {
    return {
      ruleForm: {
        name: "admin",
        pwd: "123456",
      },
      rules: {
        name: [{ required: true, message: "请填写用户名!", trigger: "blur" }],
        pwd: [{ required: true, message: "请填写密码!", trigger: "blur" }],
      },
    };
  },
  methods: {
    submitForm(formName) {
      var t = this;
      this.$refs[formName].validate((valid) => {
        if (valid) {
          $http
            .get("http://localhost:5268/api/Login", {
              params: {
                name: t.ruleForm.name,
                pwd: t.ruleForm.pwd,
              },
            })
            .then((res) => {
              console.log(res);
              if (res == "3") {
                this.$message({
                  message: "账号或密码错误,请正确输入",
                  type: "error",
                });
                return false;
              }
              this.$message({
                message: "登录成功!",
                type: "success",
              });
              this.$store.commit("setRightList", res.roles);
              // this.$store.commit('setUsername', res.data.u_name)
              localStorage.setItem("name", res.data.u_True_name);
              localStorage.setItem("a", res.data.u_name);
              localStorage.setItem("b", res.data.u_True_name);
              sessionStorage.setItem("token", res.data.token);
              localStorage.setItem("c", res.data.u_id);
              t.$router.push("main");
              console.log(res);
            })
            .catch((err) => {
              this.$message({
                message: "账号或密码错误,请正确输入",
                type: "error",
              });
            });
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    },
    // submitForm(formName) {
    //     var t = this;
    //     this.$refs[formName].validate((valid) => {
    //         if (valid) {
    //                     t.$router.push('main');

    //             // $http.get('http://localhost:5074/api/Users/Login', {
    //             //     params: {
    //             //         UserLName: t.ruleForm.name,
    //             //         UserLPWD: t.ruleForm.pwd
    //             //     }
    //             // }
    //             // ).then(res => {
    //             //     console.log(res.data);
    //             //     if (res == "3") {
    //             //         this.$message({
    //             //             message: "账号或密码错误,请正确输入",
    //             //             type: 'error'
    //             //         })
    //             //         return false;
    //             //     }
    //             //     $http.get('http://localhost:5074/api/Users/SelectUsersId', {
    //             //         params: {
    //             //             username: t.ruleForm.name,
    //             //             pwd: t.ruleForm.pwd
    //             //         }
    //             //     }).then(res => {
    //             //         localStorage.setItem('id', res.userID);
    //             //         localStorage.setItem('roel', res.roleID);
    //             //         t.$router.push('main');

    //             //     })
    //             //     this.$message({
    //             //         message: "登录成功!",
    //             //         type: 'success'
    //             //     })

    //             //     localStorage.setItem('token', res);
    //             //     localStorage.setItem('name', t.ruleForm.name);

    //             // })
    //         } else {
    //             console.log('error submit!!');
    //             return false;
    //         }
    //     });
    // },
  },
};
</script>

<style>
html,
body,
#app,
#hz1 {
  height: 100%;
  background: #f4f5fa;
}
#text {
  width: 360px;
  height: 50px;
  background-color: #fff;
  box-shadow: 0px 1px 0px 0px #b7b9bf;
  border-radius: 5px;
}
#delu {
  width: 360px;
  height: 45px;
  background: #9031aa;
  margin-left: -150px;
  border-color: #9031aa;
  margin-top: 20px;
}
.el-icon-view:before {
  content: "\e6ce";
  margin-left: 62px;
  line-height: 50px;
}
.z {
  width: 1009px;
  height: 100%;
  background: #fff;
  position: relative;
  display: inline;
  float: left;
}
.y {
  float: right;
  width: 410px;
  height: 100%;
  background: #f4f5fa;
  position: relative;
}
.z .s {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.demo-ruleForm {
  width: 60%;
  transform: translate(30%, 200px);
}
</style>