using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;

namespace WMS.Domain.Repository
{
    public interface IUsersRepository
    {

        //登录
        Users LoginUsers(string name, string pwd);


        //查询
        FenYe<Users> UsersSelectAsync(int page, int pageSize,string zh,string xm,string zt);

        //树状查询
        Task<IEnumerable<Trees>> GetTrees(int roleId);

      


        Task<FenYeUsers<UserRoleView>> FindUser(int PageSize, int CurrentPage, string str);

        //修改用户状态

        Task<bool> UpdateUsersState(int u_id, string u_State);

        //新增
        Task<int> AddUsers(string u_name, string U_True_name, string U_password, string U_State, string is_del,int rolesId);
        //用户角色

        Task<int> UpdateUsers(string u_name, string U_True_name, string U_password, int rolesId, int u_id, int UserRolesID);

        Task<bool> DeleteUsers(int u_id, string is_del);


    }
}
