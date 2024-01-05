using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;
using WMS.Domain.Repository;

namespace WMS.EFCore.Repository
{
    public class UsersRepository : IUsersRepository
    {
        private readonly MyContext myContext;

        public UsersRepository(MyContext context)
        {
            this.myContext = context;
        }
        //树状查询

        public  async Task<IEnumerable<Trees>> GetTrees(int roleId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT  J.AuthorityID AS AuthorityID,J.AuthorityName AS AuthorityName,J.Pid AS Pid,J.AuthorityAddress AS AuthorityAddress\r\nFROM Users U INNER JOIN UserRoles UR ON U.U_id =UR.UserID INNER JOIN Roles R\r\nON UR.RolesID= R.RolesID INNER JOIN RolesAuthority JR ON R.RolesID= JR.RolesID INNER JOIN  Authority J\r\nON JR.AuthorityID=J.AuthorityID WHERE U.U_id='{roleId}'";
                List<Authority> quans = (List<Authority>)await con.QueryAsync<Authority>(sql); 
                List<Trees> trees =  GetTreesDate(quans,0);
                return trees;
            }
        }

       

        public  List<Trees> GetTreesDate(List<Authority> list, int pid)
        {
            List<Trees> trees = new List<Trees>();
            List<Authority> plist=list.Where(e=> e.Pid==pid).ToList();
            foreach (Authority item in plist)
            {
                Trees trees1 = new Trees()
                {
                    id = item.AuthorityID,
                    text = item.AuthorityName,
                    url = item.AuthorityAddress,                 
                    children = GetTreesDate(list,item.AuthorityID)
                };
                trees.Add(trees1);
            }
            return trees;
        }

        //登录
      

        //分页查询用户
       

       
        public FenYe<Users> UsersSelectAsync(int page, int pageSize, string zh, string xm, string zt)
        {
            if (page == 0) { page = 1; }
            var query = myContext.Users.AsQueryable();
            query = query.Where(p => p.is_del.Contains("0"));

            if (!string.IsNullOrEmpty(zh))
            {
                query = query.Where(p => p.U_name.Contains(zh));
            }
            if (!string.IsNullOrEmpty(xm))
            {
                query = query.Where(p => p.U_True_name.Contains(xm));
            }
            if (!string.IsNullOrEmpty(zt))
            {
                query = query.Where(p => p.U_State.Contains(zt));
            }
        

            var totalCount = query.Count();

            var products = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return new FenYe<Users>(products, totalCount, page, pageSize);
        }

       



        public Users LoginUsers(string name, string pwd)
        {
            
                return myContext.Users.FirstOrDefault(e => e.U_name == name && e.U_password == pwd);
           
        }

        public async Task<FenYeUsers<UserRoleView>> FindUser(int PageSize,int CurrentPage, string str)
        {
          
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "u_id");
                param.Add("@tableName", "UserRoleView");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<UserRoleView> fenYe = new FenYeUsers<UserRoleView>();
                fenYe.List = await connection.QueryAsync<UserRoleView>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;
            }
           

        }

       

        public async Task<bool> UpdateUsersState(int u_id, string u_State)
        {
            var a = myContext.Users.Find(u_id);
            a.U_State=u_State;
            myContext.Users.Update(a);
            return await myContext.SaveChangesAsync()>0 ? true:false;
        }

        public async Task<int> AddUsers(string u_name, string U_True_name, string U_password, string U_State, string is_del, int rolesId)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string pwd = MMJM.GetPwd(U_password);
                DynamicParameters dynamic = new DynamicParameters();
                dynamic.Add("@userName", u_name);
                dynamic.Add("@userPwd", pwd);
                dynamic.Add("@rolesID", rolesId);
                dynamic.Add("@userTrueName", U_True_name);
                dynamic.Add("@U_State", U_State);
                dynamic.Add("@is_del", is_del);
                string sql = "exec [dbo].[UserAdd] @userName, @userPwd, @userTrueName,@U_State,@is_del,@rolesID";
                return await connection.ExecuteAsync(sql, dynamic);
            }
         }

        public async Task<int> UpdateUsers(string u_name, string U_True_name, string U_password, int rolesId, int u_id,int UserRolesID)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string pwd = MMJM.GetPwd(U_password);
                DynamicParameters dynamic = new DynamicParameters();
                dynamic.Add("@userName", u_name);
                dynamic.Add("@UserRolesID", UserRolesID);
                dynamic.Add("@userID", u_id);
                dynamic.Add("@userPwd", pwd);
                dynamic.Add("@userTrueName", U_True_name);
                dynamic.Add("@rolesID", rolesId);
                string sql = "exec [dbo].[UserUpdate] @userID, @userName, @userPwd, @userTrueName,@UserRolesID, @rolesID";
                return await con.ExecuteAsync(sql, dynamic);
            }
        }

        public async Task<bool> DeleteUsers(int u_id, string is_del)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"UPDATE Users set is_del='{is_del}' where u_id='{u_id}'";
                return await con.ExecuteAsync(sql)>0 ? true : false;
            }
         }
    }
}
