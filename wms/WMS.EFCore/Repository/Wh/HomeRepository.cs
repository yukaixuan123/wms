using Dapper;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;

namespace WMS.EFCore.Repository.Wh
{
    public class HomeRepository: IHomeRepository
    {
        private readonly MyContext myContext;
        public HomeRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }
        /// <summary>
        /// 入库统计
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<ST1>> HomeRKAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT top 7 CAST(inbll_date as DATE ) as inbll_date,     \r\n       SUM(total_buy_num) as total_buy_num,     \r\n       SUM(total_price) as total_price    \r\nFROM [dbo].[ST]\r\nwhere inbill_state=2\r\nGROUP BY CAST(inbll_date as DATE )\r\norder by inbll_date DESC  ";
                return await connection.QueryAsync<ST1>(sql);
            }
        }
        /// <summary>
        /// 出库统计
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<ST2>> HomeCKAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT top 7 CAST(outbill_date as DATE ) as outbill_date,     \r\n       SUM(total_buy_num) as total_buy_num,     \r\n       SUM(total_price) as total_price    \r\nFROM [dbo].[ST1]\r\n where outbill_state=2\r\nGROUP BY CAST(outbill_date as DATE )\r\norder by outbill_date DESC";
                return await connection.QueryAsync<ST2>(sql);
            }
        }
        /// <summary>
        /// 库存数量占比
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_now_storage>> HomeSLAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select  top 7 ware_code,SUM(inbill3_num) as inbill3_num  from [dbo].[Wh_now_storage]\r\nwhere is_del=0\r\nGROUP BY ware_code order by SUM(inbill3_num)";
                return await connection.QueryAsync<Wh_now_storage>(sql);
            }
        }
        /// <summary>
        /// 库存货品数量占比
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_now_storage1>> HomeHPSLAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select top 7 b.item_name,SUM(inbill3_num) as inbill3_num  from [dbo].[Wh_now_storage] w inner join\r\n[dbo].[Bs_item] b on w.item_code=b.item_code\r\nwhere w.is_del=0\r\nGROUP BY b.item_name order by SUM(inbill3_num) desc";
                return await connection.QueryAsync<Wh_now_storage1>(sql);
            }
        }

        public int hpslSUM()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"select SUM(inbill3_num) as inbill3_num from [dbo].[Wh_now_storage] w inner join
                                [dbo].[Bs_item] b on w.item_code=b.item_code
                                where w.is_del=0";
                return connection.QueryFirst<int>(sql);
            }
        }

        public int kcslSUM()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"select SUM(inbill3_num) as inbill3_num  from [dbo].[Wh_now_storage]
                                where is_del=0
                                order by SUM(inbill3_num) ";
                return connection.QueryFirst<int>(sql);
            }
        }
        /// <summary>
        /// 入库今日概况
        /// </summary>
        /// <returns></returns>
        public async Task<ToYesCount> ToCountRKAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT COUNT(*) AS To_Table1Count,SUM(total_buy_num) To_total_buy_num,SUM(total_price) To_total_price\r\nFROM [dbo].[ST]\r\nWHERE DateDiff(dd, inbll_date, GetDate()) = 0";
                return await connection.QueryFirstAsync<ToYesCount>(sql);
            }
        }
        /// <summary>
        /// 入库昨日概况
        /// </summary>
        /// <returns></returns>
        public async Task<ToYesCount> YesCountRKAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT COUNT(*) AS Yes_Table1Count,SUM(total_buy_num) Yes_total_buy_num,SUM(total_price) Yes_total_price\r\nFROM [dbo].[ST]\r\nWHERE DateDiff(dd, inbll_date, GetDate()) = 1";
                return await connection.QueryFirstAsync<ToYesCount>(sql);
            }
        }

        /// <summary>
        /// 出今日概况
        /// </summary>
        /// <returns></returns>
        public async Task<ToYesCount> ToCountCKAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT COUNT(*) AS To_Table1Count1,SUM(total_buy_num) To_total_buy_num1,SUM(total_price) To_total_price1\r\nFROM [dbo].[ST1]\r\nWHERE DateDiff(dd, outbill_date, GetDate()) = 0";
                return await connection.QueryFirstAsync<ToYesCount>(sql);
            }
        }
        /// <summary>
        /// 出库昨日概况
        /// </summary>
        /// <returns></returns>
        public async Task<ToYesCount> YesCountCKAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT COUNT(*) AS Yes_Table1Count1,SUM(total_buy_num) Yes_total_buy_num1,SUM(total_price) Yes_total_price1\r\nFROM [dbo].[ST1]\r\nWHERE DateDiff(dd, outbill_date, GetDate()) = 1";
                return await connection.QueryFirstAsync<ToYesCount>(sql);
            }
        }

        /// <summary>
        /// 入库排名
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<PaiMing>> RKpaimingAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select TOP 10 COUNT(*) number, b.item_name item_name,SUM(d.inbill_num) inbill_num,SUM(d.buy_price) buy_price\r\nfrom [dbo].[Wh_inbill_d] d inner join [dbo].[Bs_item] b on d.item_code=b.item_code\r\nGROUP BY b.item_name\r\nORDER BY COUNT(*) DESC";
                return await connection.QueryAsync<PaiMing>(sql);
            }
        }
        /// <summary>
        /// 出库排名
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<PaiMing>> CKpaimingAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select TOP 10 COUNT(*) number1, b.item_name item_name1,SUM(d.outbill_num) outbill_num1,SUM(d.sale_price) sale_price1\r\nfrom [dbo].[Wh_outbill_d] d inner join [dbo].[Bs_item] b on d.item_code=b.item_code\r\nGROUP BY b.item_name\r\nORDER BY COUNT(*) DESC";
                return await connection.QueryAsync<PaiMing>(sql);
            }
        }
        /// <summary>
        /// 全部待审核
        /// </summary>
        /// <returns></returns>
        public async Task<IEnumerable<Alldsh>> ALLdskAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_buy_order_h]\r\nWHERE sale_state='0'  and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_return_supply_h]\r\nWHERE sale_state='0' and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_sale_h]\r\nWHERE sale_state='0'  and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_sale_return_h]\r\nWHERE sale_state='0' and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_inbill_h]\r\nWHERE inbill_state='0'  and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_outbill_h]\r\nWHERE outbill_state='0'  and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_inventory_h]\r\nWHERE sure_state='0'  and is_del=0\r\nUNION ALL\r\nSELECT count(0) AS stateSum\r\nFROM [dbo].[Wh_transfer_h]\r\nWHERE sure_state='0' and is_del=0";
                return await connection.QueryAsync<Alldsh>(sql);
            }
        }

        /// <summary>
        /// 全部待入库
        /// </summary>
        /// <returns></returns>
        public int ALLrkAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"select count(0) allrk from [dbo].[Wh_inbill_h] where inbill_state='0' and is_del=0";
                return  connection.QueryFirst<int>(sql);
            }
        }
        /// <summary>
        /// 全部待出库
        /// </summary>
        /// <returns></returns>
        public int ALLckAsync()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"select count(0) outck from [dbo].[Wh_outbill_h]  where outbill_state='0' and is_del=0";
                return  connection.QueryFirst<int>(sql);
            }
        }
    }
}
