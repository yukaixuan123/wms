using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Cm;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace WMS.EFCore.Repository.Cm
{
    public class Bs_itemtypeRepository : IBs_itemtypeRepository
    {
        private readonly MyContext myContext;
        public Bs_itemtypeRepository(MyContext context)
        {
            this.myContext = context;
        }
        string constr = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";
        /// <summary>
        /// 添加货品类型
        /// </summary>
        /// <param name="itemType">货品类型实体类</param>
        /// <returns></returns>
        public async Task<bool> ItemTypeAddAsync(Bs_item_type itemType)
        {
            myContext.bs_Item_Types.Add(itemType);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 货品类型逻辑删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        public async Task<bool> ItemTypeDeleteAsync(int id, string bl)
        {
            var ee = myContext.bs_Item_Types.Find(id);
                ee.is_del = bl;
            myContext.bs_Item_Types.Update(ee);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 查询全部货品类型
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_item_type>> ItemTypeSelectAsync()
        {
            return myContext.bs_Item_Types.ToListAsync();
        }
        /// <summary>
        /// 修改货品类型
        /// </summary>
        /// <param name="itemType">货品类型实体类</param>
        /// <returns></returns>
        public async Task<bool> ItemTypeUpdateAsync(Bs_item_type itemType)
        {
            myContext.bs_Item_Types.Update(itemType);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 货品类型模糊条件查询
        /// </summary>
        /// <param name="bh">编号</param>
        /// <param name="zt">状态</param>
        /// <param name="czr">操作人</param>
        /// <param name="sj">时间</param>
        /// <returns></returns>
        public IEnumerable<Bs_item_type> ItemTypeMHAsync(string bh,string zt,string czr,string sj)
        {
            //var pp= myContext.bs_Item_Types
            //    .Where(x =>x.is_del.Contains("0")
            //    && x.item_type_code.Contains(bh)
            //    || x.item_type_name.Contains(bh)
            //    || x.inbill_state.Contains(zt)
            //    || x.create_by.Contains(czr)
            //    || x.create_time.Equals(sj)).ToList();
            //return pp;
            var qq = myContext.bs_Item_Types.AsQueryable();
            qq = qq.Where(x => x.is_del.Contains("0"));
            if(!string.IsNullOrEmpty(bh))
            {
                qq = qq.Where(x => x.is_del.Contains("0") && x.item_type_code.Contains(bh) || x.item_type_name.Contains(bh));
            }
            if(!string.IsNullOrEmpty(zt))
            {
                qq = qq.Where(x => x.inbill_state.Contains(zt));
            }
            if(!string.IsNullOrEmpty(czr))
            {
                qq = qq.Where(x => x.create_by.Contains(czr));
            }
            if(!string.IsNullOrEmpty(sj))
            {
                qq = qq.Where(x => x.create_time.Equals(sj));
            }
            return qq;
        }
        /// <summary>
        /// 根据id查名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<string> SelectIdAsync(int id)
        {
            var name = await myContext.bs_Item_Types
            .Where(item => item.item_type_id == id)
            .Select(item => item.item_type_name)
            .FirstOrDefaultAsync();
            return name;
        }
        /// <summary>
        /// 操作人下拉框
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Users>> CzrAsync()
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = " select U_id,U_True_name from Users where is_del = 0";
                return await con.QueryAsync<Users>(sql);
               
            }
        }
        /// <summary>
        /// 货品类型批量删除
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public async Task<bool> PLDeleteItemType(int[] num)
        {
            for(int i = 0; i < num.Length; i++)
            {
                var ee = myContext.bs_Item_Types.Find(num[i]);
                ee.is_del = "1";
                myContext.bs_Item_Types.Update(ee);
                await myContext.SaveChangesAsync();
            }
            return true;
        }

        public async Task<Bs_item_type> ITSelectIDAsync(int id)
        {
            using(SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from bs_item_type where item_type_id = '{id}'";
                return await con.QueryFirstAsync<Bs_item_type>(sql);
            }
        }

        public async Task<IEnumerable<GoodsCascader>> fatherGoodsFind()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Bs_item_type";
                List<Bs_item_type> quans = (List<Bs_item_type>)await con.QueryAsync<Bs_item_type>(sql);
                List<GoodsCascader> trees = await GetCascader(quans,"0" );
                return trees;
            }
        }
        private async Task<List<GoodsCascader>> GetCascader(List<Bs_item_type> list, string pid)
        {
            List<GoodsCascader> trees = new List<GoodsCascader>();
            List<Bs_item_type> plist = list.Where(e => e.father_code == pid.ToString()).ToList();
            foreach (Bs_item_type item in plist)
            {
                GoodsCascader trees1 = new GoodsCascader()
                {
                    item_type_code = item.item_type_code,
                  
                    inbill_state=item.inbill_state,
                    remark=item.remark,
                    value=item.item_type_code,
                    sort_code=item.sort_code,
                    create_by=item.create_by,
                    create_time=item.create_time,
                    pid = item.father_code,
                    children = await GetCascader(list, item.item_type_code)
                };
                trees.Add(trees1);
            }
            return trees;
        }

        public async Task<FenYeUsers<Bs_item_type>> FindGoodsType(int pageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", pageSize);
                param.Add("@keyName", "item_type_id");
                param.Add("@tableName", "Bs_item_type");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<Bs_item_type> fenYe = new FenYeUsers<Bs_item_type>();
                fenYe.List = await connection.QueryAsync<Bs_item_type>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;
            }
        }

        public async Task<bool> AddGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, int sort_code, string remark, string create_by,string is_del)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"INSERT INTO Bs_item_type(father_code,item_type_code,item_type_name,inbill_state,sort_code,remark,create_by,create_time,is_del)VALUES('{father_code}','{item_type_code}','{item_type_name}','{inbill_state}','{sort_code}','{remark}','{create_by}',getdate(),'{is_del}')";
                return await connection.ExecuteAsync(sql) > 0 ? true:false;
            }
        }

        public async Task<bool> UpdateGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, string sort_code, string remark, string update_by,int item_type_id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"UPDATE Bs_item_type SET father_code='{father_code}',item_type_code='{item_type_code}',item_type_name='{item_type_name}',inbill_state='{inbill_state}',sort_code='{sort_code}',remark='{remark}',update_by='{update_by}',update_time=getdate() WHERE item_type_id={item_type_id}";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<IEnumerable<GoodsCascader>> fatherGoodsFindById(int id)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Bs_item_type WHERE item_type_id='{id}'";
                List<Bs_item_type> quans = (List<Bs_item_type>)await con.QueryAsync<Bs_item_type>(sql);
                List<GoodsCascader> trees = await GetCascader(quans, "0");
                return trees;
            }
        }
    }
}
