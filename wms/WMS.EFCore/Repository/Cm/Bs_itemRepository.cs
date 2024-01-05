using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Repository.Cm;
using WMS.EFCore.Migrations;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace WMS.EFCore.Repository.Cm
{
    public class Bs_itemRepository : IBs_itemRepository
    {
        private readonly MyContext myContext;
        public Bs_itemRepository(MyContext context)
        {
            this.myContext = context;
        }
        string constr = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";
        /// <summary>
        /// 货品类型下拉框
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Bs_item_type>> BsItemTypesAsync()
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = "select item_type_id,item_type_name from Bs_item_type where is_del = 0";
                return await con.QueryAsync<Bs_item_type>(sql);
            }
        }
        /// <summary>
        /// 添加货品信息
        /// </summary>
        /// <param name="Bs_Item">货品信息实体类</param>
        /// <returns></returns>
        public async Task<bool> ItemAddAsync(Bs_item Bs_Item)
        {
            myContext.bs_Items.Add(Bs_Item);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 货品信息逻辑删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        public async Task<bool> ItemDeleteAsync(int id,string bl)
        {
            var ee = myContext.bs_Items.Find(id);
            ee.is_del = bl;
            myContext.bs_Items.Update(ee);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 货品信息分页查询
        /// </summary>
        /// <param name="page">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="bh">编号</param>
        /// <param name="zt">状态</param>
        /// <param name="lx">类型</param>
        /// <param name="dw">单位</param>
        /// <returns></returns>
        public FenYe<Bs_item> ItemFenYeAsync(int page, int pageSize, string bh,string zt,string lx,string dw)
        {
            //var query = context.TableA
            //        .Include(a => a.TableBs)
            //            .ThenInclude(b => b.TableCs)
            //        .Where(a => a.SomeProperty == someValue); // 添加条件查询

            //if (!string.IsNullOrEmpty(keyword))
            //{
            //    query = query.Where(a => a.Name.Contains(keyword)); // 添加模糊查询
            //}

            //var result = await query.Skip(pageNumber * pageSize)
            //                        .Take(pageSize)
            //                        .ToListAsync(); // 添加分页

            if (page == 0) { page = 1; }
            var query = myContext.bs_Items.AsQueryable();
            query = query.Where(p => p.is_del.Contains("0"));

            if (!string.IsNullOrEmpty(bh))
            {
                query = query.Where(p => p.is_del.Contains("0") && p.item_code.Contains(bh)||p.item_name.Contains(bh));
            }

            if(!string.IsNullOrEmpty(zt))
            {
                query = query.Where(p => p.inbill_state.Contains(zt));
            }
            if (!string.IsNullOrEmpty(lx))
            {
                query = query.Where(p => p.item_type.Contains(lx));
            }
            if (!string.IsNullOrEmpty(dw))
            {
                query = query.Where(p => p.unit.Contains(dw));
            }

            var totalCount = query.Count();

            var products = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return new FenYe<Bs_item>(products, totalCount, page, pageSize);
        }
        /// <summary>
        /// 查询全部货品信息
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_item>> ItemSelectAsync()
        {
            return myContext.bs_Items.ToListAsync();
        }
        /// <summary>
        /// 修改货品信息
        /// </summary>
        /// <param name="Bs_Item">货品信息实体类</param>
        /// <returns></returns>
        public async Task<bool> ItemUpdateAsync(Bs_item Bs_Item)
        {
            myContext.bs_Items.Update(Bs_Item);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 货品信息批量删除
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public async Task<bool> PLDeleteItem(int[] num)
        {
            for(int i = 0; i < num.Length; i++)
            {
                var ee = myContext.bs_Items.Find(num[i]);
                ee.is_del = "1";
                myContext.bs_Items.Update(ee);
                await myContext.SaveChangesAsync();
            }
            return true;
        }

        public async Task<FenYeUsers<GoodsInfo>> FindGoodsInfo(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "item_type_code");
                param.Add("@tableName", "GoodsInfo");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<GoodsInfo> fenYe = new FenYeUsers<GoodsInfo>();
                fenYe.List = await connection.QueryAsync<GoodsInfo>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        public async Task<bool> AddGoodsInfo(string item_name, string item_code, string item_type, string model_code, decimal inbill_price, decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark,string unit, string item_type_code, string ImgUrl)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"INSERT INTO Bs_item(item_name,item_code,item_type,model_code,inbill_price,outbill_price,sort_code,inbill_state,create_by,remark,is_del,create_time,unit,item_type_code,ImgUrl)" +
                    $"VALUES('{item_name}','{item_code}','{item_type}','{model_code}','{inbill_price}','{outbill_price}','{sort_code}','{inbill_state}','{create_by}','{remark}',0,getdate(),'{unit}','{item_type_code}','{ImgUrl}')";
                return await connection.ExecuteAsync(sql)>0 ? true : false;
            }
        }

        public async Task<Bs_item_type> FindGoodsInfoById(string id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select item_type_code from  Bs_item_type where item_type_id='{id}'";
                return await connection.QueryFirstAsync<Bs_item_type>(sql);
            }
         }

        public async Task<GoodsInfo> FindGoodsIfoByItem_Id(int id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from  GoodsInfo where item_id='{id}'";
                return await connection.QueryFirstAsync<GoodsInfo>(sql);
            }
        }

        public async Task<bool> UpdateGoodsInFO(string item_name, string item_code, string item_type, string model_code, decimal inbill_price, decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, int item_type_id, string ImgUrl)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"UPDATE Bs_item SET item_name='{item_name}',item_code='{item_code}',item_type='{item_type}',model_code='{model_code}',inbill_price='{inbill_price}',outbill_price='{outbill_price}',sort_code='{sort_code}',inbill_state='{inbill_state}',update_by='{create_by}',update_time=getdate(),remark='{remark}',unit='{unit}',item_type_code='{item_type_code}',ImgUrl='{ImgUrl}' where item_id='{item_type_id}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<IEnumerable<PurchaseRecord>> FindPurchaseRecord(string item_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * FROM [dbo].[view_Order1] WHERE item_code='{item_code}' AND is_del=0";
                return await connection.QueryAsync<PurchaseRecord>(sql);
            }
        }

        public async Task<IEnumerable<Inventory>> FindWh_now_storage(string item_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * FROM Wh_now_storage WHERE item_code='{item_code}'";
                return await connection.QueryAsync<Inventory>(sql);
            }
        }

        public async Task<FenYeUsers<XiaoshouJL>> FindXiaoshouJl(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "item_code");
                param.Add("@tableName", "view_xiaoshouJL");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<XiaoshouJL> fenYe = new FenYeUsers<XiaoshouJL>();
                fenYe.List = await connection.QueryAsync<XiaoshouJL>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        public async Task<FenYeUsers<InventoryRecords>> FindInventoryRecords(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "item_code");
                param.Add("@tableName", "KK1");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<InventoryRecords> fenYe = new FenYeUsers<InventoryRecords>();
                fenYe.List = await connection.QueryAsync<InventoryRecords>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        public async Task<FenYeUsers<TransferRecords>> FindTransferRecords(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "item_code");
                param.Add("@tableName", "KK2");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<TransferRecords> fenYe = new FenYeUsers<TransferRecords>();
                fenYe.List = await connection.QueryAsync<TransferRecords>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        public async Task<FenYeUsers<RkST>> FindRkst(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "item_code");
                param.Add("@tableName", "gysRk");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<RkST> fenYe = new FenYeUsers<RkST>();
                fenYe.List = await connection.QueryAsync<RkST>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        public async Task<FenYeUsers<CkST>> FindCkSt(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "item_code");
                param.Add("@tableName", "KK");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<CkST> fenYe = new FenYeUsers<CkST>();
                fenYe.List = await connection.QueryAsync<CkST>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        //public string[] FindGoodsIfoByItem_Id1(int id)
        //{
        //    using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
        //    {
        //        //ArrayList list = new ArrayList();
        //        string[] sz = new string[100];
        //        string x = id.ToString();
        //        do
        //        {
        //            string sql = $"select father_code  from [dbo].[Bs_item_type] where item_type_id={x}";
        //            object y = connection.QueryFirstAsync<GoodsInfo>(sql);
        //            if (y.ToString() != "0")
        //            {
        //                x = y.ToString();
        //                // list.Add(y);
        //                sz.Append(y.ToString());
        //            }
        //            else
        //            {
        //                break;
        //            }
        //        } while (true);
        //        return sz;
        //        // await Console.Out.WriteLineAsync(list.ToString());
        //        //string sql = $"select * from  GoodsInfo where item_id='{id}'";
        //        //return connection.QueryAsync<GoodsInfo>(list);

        //    }
        //}

    }
}
