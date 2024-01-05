using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.AppService;
using WMS.AppService.Dtos.Sys;
using WMS.AppService.Dtos.Users;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;
using WMS.Domain.Repository;


namespace WMS.AppService.AppService
{
    public class UsersAppService:IUsersAppService
    {
        private readonly IUsersRepository us;
        private readonly IMapper mapper;
        public UsersAppService(IUsersRepository us,IMapper mapper) { 
            this.us = us;
            this.mapper = mapper;
        }

      

        public async Task<int> AddUsers(string u_name, string U_True_name, string U_password, string U_State, string is_del, int rolesId)
        {
            return await us.AddUsers(u_name,U_True_name,U_password,U_State,is_del,rolesId);
        }

        public async Task<bool> DeleteUsers(int u_id, string is_del)
        {
           return await us.DeleteUsers(u_id,is_del);
        }

        public async Task<FenYeUsers<UserRoleView>> FindUser(int PageSize, int CurrentPage,  string str)
        {
          return await us.FindUser(PageSize,CurrentPage, str);
        }

        public async Task<IEnumerable<Trees>> GetTrees(int roleId)
        {
            return await us.GetTrees(roleId);
        }

        

        public  Users LoginUsers(string name, string pwd)
        {
        
            return  us.LoginUsers(name, pwd);
        }

        public async Task<int> UpdateUsers(string u_name, string U_True_name, string U_password, int rolesId, int u_id, int UserRolesID)
        {
            return await us.UpdateUsers(u_name,U_True_name,U_password,rolesId,u_id,UserRolesID);
        }

        public async Task<bool> UpdateUsersState(int u_id, string u_State)
        {
           
            return await us.UpdateUsersState(u_id,u_State);
        }

        //分页用户查询


        public  FenYe<Users> UsersSelectAsync(int page, int pageSize, string zh, string xm, string zt)
        {
            return us.UsersSelectAsync(page,pageSize,zh,xm,zt);
        }

        //分页条件查询


      
    }
}
