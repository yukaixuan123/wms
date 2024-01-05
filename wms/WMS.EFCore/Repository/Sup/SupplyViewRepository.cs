using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Sup;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace WMS.EFCore.Repository.Sup
{
    public class SupplyViewRepository : ISupplyViewRepository
    {
        private readonly MyContext myContext;
        public SupplyViewRepository(MyContext context)
        {
            this.myContext = context;
        }
        string constr = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";
        /// <summary>
        /// 供应商管理分页查询
        /// </summary>
        /// <param name="currentPage">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="str">条件</param>
        /// <returns></returns>
        public async Task<FenYeSupply<SupplyView>> FenYeAsync(int currentPage, int pageSize,string str)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "supply_id");
                dynamicParameters.Add("@tableName", "SupplyView");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeSupply<SupplyView> fenYe = new FenYeSupply<SupplyView>();
                fenYe.List = await con.QueryAsync<SupplyView>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }
        /// <summary>
        /// 银行添加
        /// </summary>
        /// <param name="bs_Finance"></param>
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
        /// 供应商分类下拉框
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Bs_supply>> FLAsync()
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = "select DISTINCT supply_type_code from bs_supply where is_del = '0'";
                return await con.QueryAsync<Bs_supply>(sql);
            }
        }
        /// <summary>
        /// 所属行业下拉框
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Bs_supply>> HYAsync()
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = "select DISTINCT line_type from Bs_supply where is_del = '0'";
                return await con.QueryAsync<Bs_supply>(sql);
            }
        }

        /// <summary>
        /// 供应商管理批量删除
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public async Task<bool> PLDeleteSupply(int[] num)
        {
            for(int i = 0; i < num.Length; i++)
            {
                var ee = myContext.bs_Supplies.Find(num[i]);
                ee.is_del = "1";
                myContext.bs_Supplies.Update(ee);
                await myContext.SaveChangesAsync();
            }
            return true;
        }

        /// <summary>
        /// 供应商管理逻辑删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        public async Task<bool> SupplyDeleteAsync(int id, string bl)
        {
            var ss = myContext.bs_Supplies.Find(id);
            ss.is_del = bl;
            myContext.bs_Supplies.Update(ss);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 供应商管理添加
        /// </summary>
        /// <param name="bs_Supply">供应商实体类</param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public async Task<bool> SupplyInsertAsync(string code,string name,string type,string typecode,string man,string tel,string yx,string sdman,string zt,string adr,string cz,string bz)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                int oo = con.QuerySingleOrDefault<int>("select max(finance_id) from bs_finance where fis_del = '0';");
                string sql = $@"insert into Bs_supply(supply_code, supply_name, line_type, supply_type_code, link_man, link_tel, e_mail, stock_duty_man, inbill_state, supply_adr, finance_id, operatoro, is_del, remark) values('{code}','{name}','{type}','{typecode}','{man}','{tel}','{yx}','{sdman}','{zt}','{adr}','{oo}','{cz}','0','{bz}');";

                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 当前用户
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public async Task<Users> UsersID(string username, string password)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"SELECT * FROM [dbo].[Users] Where U_name='{username}' and U_password='{password}'";
                return await con.QueryFirstOrDefaultAsync<Users>(sql);
            }
        }
        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<SupplyView> SelectIDAsync(int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from SupplyView where supply_id = '{id}'";
                return await con.QueryFirstAsync<SupplyView>(sql);
            }
        }
        public async Task<SupplyView> SelectCodeAsync(string id)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from SupplyView where supply_name = '{id}'";
                return await con.QueryFirstAsync<SupplyView>(sql);
            }
        }
        /// <summary>
        /// 供应商修改
        /// </summary>
        /// <param name="code"></param>
        /// <param name="name"></param>
        /// <param name="type"></param>
        /// <param name="typecode"></param>
        /// <param name="man"></param>
        /// <param name="tel"></param>
        /// <param name="yx"></param>
        /// <param name="fz"></param>
        /// <param name="zt"></param>
        /// <param name="adr"></param>
        /// <param name="cz"></param>
        /// <param name="bz"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<bool> SupplyUpdateAsync(string code,string name,string type,string typecode,string man,string tel,string yx,string fz,string zt,string adr,string cz,string bz,int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"update SupplyView set supply_code = '{code}',supply_name = '{name}',line_type = '{type}',supply_type_code = '{typecode}',
                link_man = '{man}',link_tel = '{tel}',e_mail = '{yx}',stock_duty_man = '{fz}',inbill_state = '{zt}',supply_adr = '{adr}',operatoro = '{cz}',remark = '{bz}' where supply_id = '{id}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 银行修改
        /// </summary>
        /// <param name="bs_Finance"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance,int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string oo = $@"select finance_id from SupplyView where supply_id = '{id}'";
                int pp = await con.ExecuteScalarAsync<int>(oo);
                string sql = $@"update Bs_finance set finance_name = '{bs_Finance.finance_name}',tax_no = '{bs_Finance.tax_no}',bank_no = '{bs_Finance.bank_no}',open_bank = '{bs_Finance.open_bank}',open_adr = '{bs_Finance.open_adr}' where finance_id = '{pp}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 供应商名称是否存在
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public async Task<int> SupplyNameAsync(string name)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select COUNT(0) from Bs_supply where supply_name = '{name}'";
                return await con.ExecuteScalarAsync<int>(sql);
            }
        }
        public async Task<IEnumerable<Users>> CzrAsync()
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = " select U_id,U_True_name from Users where is_del = 0";
                return await con.QueryAsync<Users>(sql);

            }
        }

        public async Task<FenYeSupply<gysRK>> FenYegysRKAsync(int page, int pageSize, string str)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "inbill_code");
                dynamicParameters.Add("@tableName", "gysRK");
                dynamicParameters.Add("@currentPage", page);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeSupply<gysRK> fenYe = new FenYeSupply<gysRK>();
                fenYe.List = await con.QueryAsync<gysRK>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

    }
}
