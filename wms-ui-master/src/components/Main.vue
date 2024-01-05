<template>
  <el-container class="home-container">
    <!-- 头部区域 -->

    <!-- 页面主体区域 -->
    <el-container>
      <!-- 侧边栏 -->
      <el-aside width="collapse">
        <!-- 侧边栏菜单区域 -->
        <el-menu
          text-color="#000"
          unique-opened
          :collapse="isCollapse"
          router
          :default-active="activePath"
          class="el-menu-vertical"
          background-color="#F4F5FA"
          active-text-color="rgb(64, 158, 255)"
        >
          <div>
            <img src="../Images/loho1.png" width="220px" height="55px" />
          </div>
          <el-submenu index="0">
            <template slot="title"
              ><i class="el-icon-s-home"></i
              ><span>
                <router-link
                  :to="{ path: '/Home' }"
                  target="main"
                  style="color: black"
                >
                  首页
                </router-link>
              </span></template
            >
          </el-submenu>
          <!-- 一级菜单 -->
          <el-submenu
            :index="item.id + ''"
            v-for="item in menulist"
            :key="item.id"
          >
            <!-- 一级菜单的模板区域 -->
            <template slot="title">
              <!-- 图标 -->
              <i :class="iconobj[item.id]"></i>

              <!-- 文本 -->
              <span>{{ item.text }}</span>
            </template>
            <!-- 二级菜单 -->
            <el-menu-item
              :index="'' + subItem.url"
              v-for="subItem in item.children"
              :key="subItem.id"
              @click="saveNavState('' + subItem.url, '' + subItem.text)"
            >
              <template slot="title">
                <!-- 图标 -->
                <!-- 文本 -->
                <span>{{ subItem.text }}</span>
              </template>
            </el-menu-item>
          </el-submenu>
        </el-menu>
      </el-aside>
      <el-container>
        <el-header style="margin-left: 20px">
          <div
            :title="isCollapse ? '点击展开' : '点击收起'"
            class="box_bgd"
            @click="isC"
          >
            <!-- 点击展开收起导航和切换对应图标 -->
            <i :class="!isCollapse ? 'el-icon-s-fold' : 'el-icon-s-unfold'"></i>
          </div>
          <div>
            <div id="cover">
              <form method="get" action="">
                <div class="tb">
                  <div class="td">
                    <input type="text" placeholder="搜索" required />
                  </div>
                  <div class="td" id="s-cover">
                    <button type="submit">
                      <div id="s-circle"></div>
                      <span></span>
                    </button>
                  </div>
                </div>
              </form>
            </div>
            <ul id="ul1">
              <li>
                <el-dropdown size="medium" :hide-on-click="false">
                  <el-badge class="item"
                    ><i id="tjjj">{{ allck + allrk + allsum }}</i>
                    <a href="javascript:void(0)" class="el-dropdown-link"
                      >消息</a
                    >
                  </el-badge>
                  <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item
                      >待审核<span id="tjj">{{
                        allsum
                      }}</span></el-dropdown-item
                    >
                    <el-dropdown-item
                      >待入库<span id="tjj">{{ allrk }}</span></el-dropdown-item
                    >
                    <el-dropdown-item
                      >待出库<span id="tjj">{{ allck }}</span></el-dropdown-item
                    >
                    <el-dropdown-item disabled divided
                      >到期提醒</el-dropdown-item
                    >
                    <el-dropdown-item disabled>低库存</el-dropdown-item>
                    <el-dropdown-item disabled>高库存</el-dropdown-item>
                  </el-dropdown-menu>
                </el-dropdown>
              </li>

              <li>
                <a href="javascript:void(0)">
                  <router-link :to="{ path: '/ProjectBackground' }"
                    >项目介绍</router-link
                  ></a
                >
              </li>
              <li>
                <a href="javascript:void(0)">
                  <router-link :to="{ path: '/Home' }">项目首页</router-link></a
                >
              </li>
              <li>
                <el-dropdown @command="handleCommand">
                  <span class="el-dropdown-link">
                    <a href="javascript:void(0)"
                      ><img
                        src="../Images/maomao1.jpg"
                        width="40"
                        height="40"
                      /><span
                        style="
                          font-size: 13px;
                          font-weight: 700;
                          padding-left: 10px;
                        "
                        >{{ userName }}</span
                      ></a
                    >
                  </span>
                  <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item icon="el-icon-edit-outline" command="b"
                      >个人资料</el-dropdown-item
                    >
                    <el-dropdown-item icon="el-icon-switch-button" command="a"
                      >退货系统</el-dropdown-item
                    >
                  </el-dropdown-menu>
                </el-dropdown>
              </li>
            </ul>
          </div>
        </el-header>
        <!-- <el-tabs
          v-model="editableTabsValue"
          type="card"
          :closable="this.editableTabs.length > 1"
          @tab-remove="removeTab"
        >
          <el-tab-pane
            v-for="item in editableTabs"
            :key="item.name"
            :label="item.title"
            :name="item.name"
          >
          </el-tab-pane>
        </el-tabs> -->
        <el-main>
          <router-view></router-view>
        </el-main>
      </el-container>
    </el-container>
  </el-container>
</template>

<script>
import { mapState } from "vuex";
import $http from "../http/base";

export default {
  data() {
    return {
      // 左侧菜单数据
      menulist: [],
      // 是否折叠
      isCollapse: false,
      allsum: 0,
      allrk: 0,
      allck: 0,

      // 被激活的链接地址
      activePath: "",
      text: "",
      userName: "",
      iconobj: {
        4: "el-icon-s-goods",
        6: "el-icon-user-solid",
        7: "el-icon-s-opportunity",

        8: "el-icon-user-solid",
        10: "el-icon-s-order",
        11: "el-icon-s-custom",
        12: "el-icon-s-data",
        13: "el-icon-s-cooperation",
        14: "el-icon-s-tools",
      },
      // editableTabsValue: "1",
      // editableTabs: [
      //   // {
      //   //   title: "首页",
      //   //   name: this.$router.push("/Home"),
      //   // },
      // ],
      // tabIndex: 1,
    };
  },

  created() {
    this.activePath = window.sessionStorage.getItem("activePath");
    this.menulist = this.rightList;
    this.userName = this.username;
  },
  methods: {
    handleCommand(command) {
      // this.$message("click on item " + command);
      if (command == "a") {
        this.$confirm("确定是否退出本系统?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        })
          .then(() => {
            //清空sessionStorage
            sessionStorage.clear();
            //跳转页面
            this.$router.push("/login");
            //清空vuex
            window.location.reload();
            this.$message({
              type: "success",
              message: "退出成功!",
            });
          })
          .catch(() => {
            this.$message({
              type: "error",
              message: "已取消退出",
            });
          });
      } else {
        this.$router.push("/Users");
      }
    },
    // 动态控制展开与收起和切换对应图标
    isC() {
      this.isCollapse = !this.isCollapse;
    },
    logout() {
      //   //清空sessionStorage
      //   sessionStorage.clear();
      //   this.$router.push("/login");
      //   //清空vuex
      //   window.location.reload();
    },
    // 点击按钮，切换菜单的折叠与展开
    toggleCollapse() {
      this.isCollapse = !this.isCollapse;
    },
    // 保存链接的激活状态
    saveNavState(activePath, text) {
      window.sessionStorage.setItem("activePath", activePath);
      this.activePath = activePath;

      this.text = text;
      // let newTabName = ++this.tabIndex + "";
      // this.editableTabs.push({
      //   title: this.text,
      //   name: newTabName,
      // });
      // this.editableTabsValue = newTabName;
    },
    find() {
      $http.get("http://localhost:5149/api/Home/ALLdsk").then((res) => {
        for (let i = 0; i < res.length; i++) {
          this.allsum += res[i].stateSum;
        }
      });
      $http.get("http://localhost:5149/api/Home/ALLrk").then((res) => {
        this.allrk = res;
      });
      $http.get("http://localhost:5149/api/Home/ALLck").then((res) => {
        this.allck = res;
      });
    },
    removeTab(targetName) {
      let tabs = this.editableTabs;
      let activeName = this.editableTabsValue;
      // if (this.activeName == 1) {
      //   alert("第一个标签不能被删除！");
      //   return;
      // }
      if (activeName === targetName) {
        tabs.forEach((tab, index) => {
          if (tab.name === targetName) {
            let nextTab = tabs[index + 1] || tabs[index - 1];
            if (nextTab) {
              activeName = nextTab.name;
            }
          }
        });
      }
      this.editableTabsValue = activeName;
      this.editableTabs = tabs.filter((tab) => tab.name !== targetName);
    },
  },
  mounted() {
    this.find();
    this.userName = localStorage.getItem("a");
  },

  computed: {
    ...mapState(["rightList", "username"]),
  },
};
</script>
<style scoped src="../CSS/ss.css"></style>
<style>
.el-tabs--card > .el-tabs__header .el-tabs__item.is-active {
  border-bottom-color: transparent !important;
  background: #ebecef;
}
.el-tabs--card > .el-tabs__header {
  border-bottom: 1px solid #e4e7ed;
  margin-left: 20px;
}
.el-tabs--card > .el-tabs__header .el-tabs__nav {
  border: 1px solid #e4e7ed;
  border-bottom: none;
  border-radius: 4px 4px 0 0;
  box-sizing: border-box;
  background: #f4f5fa !important;
}
#tjjj {
  background-color: red;
  color: #fff;
  position: relative;
  bottom: 10px;
  left: 40px;
  font-size: 10px;
  border-radius: 50% 50%;
  padding: 3px;
}
#tjj {
  background-color: red;
  color: #fff;
  position: relative;
  bottom: 10px;
  left: -3px;
  font-size: 10px;
  border-radius: 50% 50%;
  padding: 3px;
}
.el-dropdown-link {
  cursor: pointer;
  color: #409eff;
}
.el-icon-arrow-down {
  font-size: 12px;
}
.el-badge__content.is-fixed {
  position: absolute;
  top: 15px !important;
  right: 10px;
  transform: translateY(-50%) translateX(100%);
}
.home-container {
  height: 100%;
}
.el-header {
  background-color: #373d41;
  display: flex;
  justify-content: space-between;
  padding-left: 0;
  align-items: center;
  color: #fff;
  font-size: 20px;
}
.el-aside {
  background: #f4f5fa;
  color: #333;
  height: auto;
  box-shadow: 2px 0 20px 3px #dcdde2;
}
.el-menu {
  border-right-width: 0;
}
.el-main {
  color: #333;
}
.iconfont {
  margin-right: 10px;
}
.toggle-button {
  background-color: #4a5064;
  font-size: 10px;
  line-height: 24px;
  color: #fff;
  text-align: center;
  letter-spacing: 0.2em;
  cursor: pointer;
}
* {
  margin: 0;
  padding: 0;
  text-decoration: none;
  list-style: none;
  outline: none;
}
html,
body,
#app,
#hz1 {
  height: 100%;
  background: #f4f5fa;
}
/* .el-submenu.is-opened .el-submenu__title {
  background-image: linear-gradient(to right, #af85fc, #9155fd);
  border-radius: 0 50px 50px 0 !important;
  color: #fff !important;
}
.el-submenu.is-opened .el-submenu__title a {
  color: #fff !important;
} */
.el-submenu__title:hover {
  background-image: linear-gradient(
    to right,
    rgb(220 222 230),
    rgb(220 222 230)
  );
}
.el-menu-item.is-active {
  background-image: linear-gradient(to right, #af85fc, #9155fd);
  border-radius: 0 50px 50px 0 !important;
}
.el-menu-item.is-active:hover {
  background-image: linear-gradient(to right, #af85fc, #9155fd);
  border-radius: 0 50px 50px 0 !important;
}
.el-menu-item:hover {
  background-image: linear-gradient(
    to right,
    rgb(220 222 230),
    rgb(220 222 230)
  );
  border-radius: 0 50px 50px 0 !important;
}
.el-menu-item.is-active {
  color: #ffffff !important;
}
.el-menu-item {
  border-radius: 0 50px 50px 0 !important;
}
/* .el-menu--horizontal > .el-menu-item.is-active {
  border-bottom: 3px solid #9427b0 !important;
  color: #9427b0 !important;
  font-weight: bold;
} */
#ul1 {
  margin-left: -420px;
  width: 425px;
  height: 60px;
}
.el-submenu__title {
  border-radius: 0 50px 50px 0 !important;
}
#ul1 li {
  float: left;
  width: 100px;
  line-height: 60px;
  text-align: center;
  font-size: 14px;
}
#ul1 li a {
  color: #454141;
}
#ul1 li:hover a {
  color: #9155fd;
}
#ul1 li img {
  display: inline-block;
  line-height: 60px;
  vertical-align: middle;
  border-radius: 5px;
}
#l1 {
  float: right;
}
.el-submenu {
  list-style: none;
  margin: 0;
  padding-left: 0;
}
.el-submenu__title:hover {
  border-radius: 10px;
}
body {
  margin: 0px !important;
}

.el-header {
  background: #f4f5fa;
  color: #333;
  padding: 0 !important;
  box-shadow: 2px 0 20px 3px #b4b5bd;
  border-radius: 5px;
}
.el-menu-vertical:not(.el-menu--collapse) {
  width: 230px;
}
/* .el-aside {
  box-sizing: border-box;
  flex-shrink: 0;
  overflow-x: auto !important;
  overflow-y: hidden !important;
}
.el-aside ::-webkit-scrollbar {
  display: none;
} */
.el-aside {
  box-sizing: border-box;
  flex-shrink: 0;
  overflow: hidden;
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.el-aside::-webkit-scrollbar {
  display: none;
}
.box_bgd {
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  float: left;
}

.box_bgd i {
  font-size: 20px;
}
</style>