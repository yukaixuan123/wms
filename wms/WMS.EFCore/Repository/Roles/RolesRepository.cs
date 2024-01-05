using Azure;
using Dapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;
using WMS.Domain.Repository;

namespace WMS.EFCore.Repository
{
    public class RolesRepository : IRolesRepository
    {
        private readonly MyContext myContext;

        public RolesRepository(MyContext context)
        {
            this.myContext = context;
        }
        public FenYe<Domain.Entity.User.Roles> Find(int page, int pageSize,string gw, string zt)
        {
            if (page == 0) { page = 1; }
            var query = myContext.Roles.AsQueryable();

            if (!string.IsNullOrEmpty(gw))
            {
                query = query.Where(p => p.RolesName.Contains(gw));
            }
            if (!string.IsNullOrEmpty(zt))
            {
                query = query.Where(p => p.RolesState.Contains(zt));
            }
            var totalCount = query.Count();
            var products = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
            .ToList();

            return new FenYe<Roles>(products, totalCount, page, pageSize);
        }

        public async Task<IEnumerable<Trees>> GetTrees()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Authority";
                List<Authority> quans = (List<Authority>)await con.QueryAsync<Authority>(sql);
                List<Trees> trees = GetTreesDate(quans, 0);
                return trees;
            }
        }
        private List<Trees> GetTreesDate(List<Authority> list, int pid)
        {
            List<Trees> trees = new List<Trees>();
            List<Authority> plist = list.Where(e => e.Pid == pid).ToList();
            foreach (Authority item in plist)
            {
                Trees trees1 = new Trees()
                {
                    id = item.AuthorityID,
                    text = item.AuthorityName,
                    url = item.AuthorityAddress,
                    pid=item.Pid,
                    children = GetTreesDate(list, item.AuthorityID)
                };
                trees.Add(trees1);
            }
            return trees;
        }

        public async Task<bool> UpdateRolesState(int roleId, string u_State)
        {
            var a = myContext.Roles.Find(roleId);
            a.RolesState = u_State;
            myContext.Roles.Update(a);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        public int[] GetQuan(int RolesID)
        {
            using (SqlConnection connection = new SqlConnection(@"Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = @$"select * from Authority A INNER JOIN RolesAuthority B ON A.AuthorityID=B.AuthorityID WHERE B.RolesID='{RolesID}' AND A.Pid !=0";
                return connection.Query<int>(sql).ToArray();
            }
        }

        public async Task<bool> DeleteRoles(int roleId)
        {
            using (SqlConnection connection = new SqlConnection(@"Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = @$" delete from RolesAuthority where RolesID='{roleId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<bool> UpdateRoles(int roleId, int pid)
        {
            using (SqlConnection connection = new SqlConnection(@"Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = @$"insert into RolesAuthority(RolesID,AuthorityID)Values('{roleId}','{pid}')";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public List<RolesAuthority> GetRolesId(int RolesID)
        {
            using (SqlConnection connection = new SqlConnection(@"Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = @$"select * from RolesAuthority where RolesID='{RolesID}'";
                return connection.Query<RolesAuthority>(sql).ToList();
            }
        }

        public async Task<FenYeUsers<Authority>> FindAuthority(int pageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", pageSize);
                param.Add("@keyName", "AuthorityID");
                param.Add("@tableName", "Authority");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<Authority> fenYe = new FenYeUsers<Authority>();
                fenYe.List = await connection.QueryAsync<Authority>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;
            }
        }

        public async Task<IEnumerable<AuthorityCascader>> AuthorityGetCascader()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Authority";
                List<Authority> quans = (List<Authority>)await con.QueryAsync<Authority>(sql);
                List<AuthorityCascader> trees =await GetCascader(quans,0);
                return trees;
            }
        }
        private async Task<List<AuthorityCascader>> GetCascader(List<Authority> list, int pid)
        {
            List<AuthorityCascader> trees = new List<AuthorityCascader>();
            List<Authority> plist = list.Where(e => e.Pid == pid).ToList();
            foreach (Authority item in plist)
            {
                AuthorityCascader trees1 = new AuthorityCascader()
                {
                    value = item.AuthorityID,
                    label = item.AuthorityName,
                    pid = item.Pid,
                    children = await GetCascader(list,item.AuthorityID)
                };
                trees.Add(trees1);
            }
            return trees;
        }

        public async Task<bool> AddAuthority(Authority authority)
        {
            myContext.Authority.Add(authority);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        public async Task<bool> UpdateAuthority(Authority authority)
        {
            myContext.Authority.Update(authority);
            return await myContext.SaveChangesAsync()>0 ? true : false;
        }

        public async Task<bool> DeleteAuthority(int aid)
        {
            var a = myContext.Authority.Find(aid);
            a.AuthorityID = aid;
            myContext.Authority.Remove(a);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
          
        }

        public async Task<bool> AddRoles(Roles roles)
        {
            myContext.Roles.Add(roles);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        public List<Roles> FindRoles()
        {
            return myContext.Roles.ToList();
        }

        public async Task<bool> RemoveRoles(int roleId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"delete  from  Roles WHERE rolesId='{roleId}'"; 
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
    }
}
