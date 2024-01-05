using Dapper;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Sup;

namespace WMS.EFCore.Repository.Sup
{
    public class CustomerViewRepository : ICustomerViewRepository
    {
        private readonly MyContext myContext;
        public CustomerViewRepository(MyContext context)
        {
            this.myContext = context;
        }
        string constr = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";
        /// <summary>
        /// 客户管理逻辑删除
        /// </summary>
        /// <param name="id">客户id</param>
        /// <param name="str">条件</param>
        /// <returns></returns>
        public async Task<bool> CustomerDeleteAsync(int id, string str)
        {
            var ss = myContext.bs_Customer.Find(id);
            ss.is_del = str;
            myContext.bs_Customer.Update(ss);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 客户管理分页查询
        /// </summary>
        /// <param name="currentPage">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="str">查询条件</param>
        /// <returns></returns>
        public async Task<FenYeSupply<CustomerView>> FenYeCustomerAsync(int currentPage, int pageSize, string str)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                DynamicParameters dd = new DynamicParameters();
                dd.Add("@pageSize", pageSize);
                dd.Add("@keyName", "customer_id");
                dd.Add("@tableName", "CustomerView");
                dd.Add("@currentPage", currentPage);
                dd.Add("@where", str);
                dd.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeSupply<CustomerView> fenYe = new FenYeSupply<CustomerView>();
                fenYe.List = await con.QueryAsync<CustomerView>(sql, dd);
                fenYe.Rows = dd.Get<int>("rows");
                return fenYe;
            }

        }
        /// <summary>
        /// 客户管理批量删除
        /// </summary>
        /// <param name="num">数组</param>
        /// <returns></returns>
        public async Task<bool> PLDeleteCustomer(int[] num)
        {
            for(int i = 0; i < num.Length; i++)
            {
                var ee = myContext.bs_Customer.Find(num[i]);
                ee.is_del = "1";
                myContext.bs_Customer.Update(ee);
                await myContext.SaveChangesAsync();
            }
            return true;
        }
        /// <summary>
        /// 银行添加
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <returns></returns>
        public async Task<bool> FinanceInsertAsync(Bs_finance bs_Finance)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"insert into Bs_finance(finance_name, tax_no, bank_no, open_bank, open_adr, finance_type, fis_del) values('{bs_Finance.finance_name}','{bs_Finance.tax_no}','{bs_Finance.bank_no}','{bs_Finance.open_bank}','{bs_Finance.open_adr}','{bs_Finance.finance_type}','0');";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 客户管理添加
        /// </summary>
        /// <param name="code">客户编码</param>
        /// <param name="name">客户名称</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="adr">客户地址</param>
        /// <param name="zt">状态</param>
        /// <param name="from">客户来源</param>
        /// <param name="fz">销售负责人</param>
        /// <param name="type">所属行业</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <returns></returns>
        public async Task<bool> CustomerInsertAsync(string code,string name,string man,string tel,string yx,string adr,string zt,string from,string fz,string type,string cz,string bz)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                int oo = con.QuerySingleOrDefault<int>("select max(finance_id) from bs_finance where fis_del = '0';");
                string sql = $@"insert into Bs_customer(cust_code, cust_name, link_man, link_tel, e_mail, cust_adr, inbill_state, cust_from, is_del, head_of_Sales, line_type, operatoro, finance_id, remark) values('{code}','{name}','{man}','{tel}','{yx}','{adr}','{zt}','{from}','0','{fz}','{type}','{cz}','{oo}','{bz}')";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 当前用户
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <returns></returns>
        public async Task<Users> UsersID(string username, string password)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from Users where U_name = '{username}' and U_password = '{password}';";
                return await con.QueryFirstOrDefaultAsync<Users>(sql);
            }
        }
        /// <summary>
        /// 客户来源下拉框
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Bs_customer>> LYAsync()
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = "select DISTINCT cust_from from Bs_customer where is_del = '0'";
                return await con.QueryAsync<Bs_customer>(sql);
            }
        }
        /// <summary>
        /// 所属行业下拉框
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Bs_customer>> HYAsync()
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = "select DISTINCT line_type from bs_customer where is_del = '0'";
                return await con.QueryAsync<Bs_customer>(sql);
            }
        }
        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public async Task<CustomerView> SelectIDAsync(int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from CustomerView where customer_id = '{id}'";
                return await con.QueryFirstAsync<CustomerView>(sql);
            }
        }
        /// <summary>
        /// 客户修改
        /// </summary>
        /// <param name="code">客户编码</param>
        /// <param name="name">客户名称</param>
        /// <param name="type">所属行业</param>
        /// <param name="from">客户来源</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="fz">销售负责人</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">客户地址</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public async Task<bool> CustomerUpdateAsync(string code,string name,string type,string from,string man,string tel,string yx,string fz,string zt,string adr,string cz,string bz,int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"update Bs_customer set cust_code = '{code}',cust_name = '{name}',line_type = '{type}',cust_from = '{from}',link_man = '{man}',link_tel = '{tel}',e_mail = '{yx}',head_of_Sales = '{fz}',inbill_state = '{zt}',cust_adr = '{adr}',operatoro = '{cz}',remark = '{bz}' where customer_id = '{id}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 银行修改
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public async Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance,int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string oo = $@"select finance_id from CustomerView where customer_id = '{id}'";
                int qq = await con.ExecuteScalarAsync<int>(oo);
                string sql = $@"update Bs_finance set finance_name = '{bs_Finance.finance_name}',tax_no = '{bs_Finance.tax_no}',bank_no = '{bs_Finance.bank_no}',open_bank = '{bs_Finance.open_bank}',open_adr = '{bs_Finance.open_adr}' where finance_id = '{qq}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 客户名称是否存在
        /// </summary>
        /// <param name="name">客户名称</param>
        /// <returns></returns>
        public async Task<int> CustomerNameAsync(string name)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select COUNT(0) from Bs_customer where cust_name = '{name}'";
                return await con.ExecuteScalarAsync<int>(sql);
            }
        }
        public async Task<CustomerView> SelectCodeAsync(string id)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from CustomerView where cust_name = '{id}'";
                return await con.QueryFirstAsync<CustomerView>(sql);
            }
        }
        public async Task<FenYeSupply<khCK>> FenYekhCKAsync(int currentPage, int pageSize, string str)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                DynamicParameters dd = new DynamicParameters();
                dd.Add("@pageSize", pageSize);
                dd.Add("@keyName", "outbill_h_id");
                dd.Add("@tableName", "KK");
                dd.Add("@currentPage", currentPage);
                dd.Add("@where", str);
                dd.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeSupply<khCK> fenYe = new FenYeSupply<khCK>();
                fenYe.List = await con.QueryAsync<khCK>(sql, dd);
                fenYe.Rows = dd.Get<int>("rows");
                return fenYe;
            }

        }
    }
}
