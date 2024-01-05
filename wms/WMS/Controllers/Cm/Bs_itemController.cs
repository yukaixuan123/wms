using Dapper;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using OfficeOpenXml.Table.PivotTable;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using WMS.AppService.AppService.Cm;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Repository.Cm;
using WMS.EFCore.Repository.Cm;

namespace WMS.Controllers.Cm
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Bs_itemController : Controller
    {
        private readonly IBs_itemService bs_ItemService;
      
        public Bs_itemController(IBs_itemService bs_ItemService)
        {
            this.bs_ItemService = bs_ItemService;
            
        }

       
        [HttpGet]
        public async Task<List<Bs_item>> Bs_itemSelectAsync()
        {
            return await bs_ItemService.ItemSelectAsync();
        }
        [HttpPost]
        public async Task<bool> Bs_itemAddAsync(AddBs_itemDtos addBs_ItemDtos)
        {
            return await bs_ItemService.ItemAddAsync(addBs_ItemDtos);
        }
        [HttpPut]
        public async Task<bool> Bs_itemUpdateAsync(UpdateBs_itemDtos updateBs_ItemDtos)
        {
            return await bs_ItemService.ItemUpdateAsync(updateBs_ItemDtos);
        }
        [HttpDelete]
        public async Task<bool> Bs_itemDeleteAsync(int id,string bl)
        {
            return await bs_ItemService.ItemDeleteAsync(id, bl);
        }
        
        [HttpGet]
        public IActionResult ItemFenYeAsync(int page,int pageSize,string bh = "",string zt = "",string lx = "",string dw = "")
        {
            string ss = string.IsNullOrEmpty(bh) ? "" : bh;
            string ss1 = string.IsNullOrEmpty(zt) ? "" : zt;
            string ss2 = string.IsNullOrEmpty(lx) ? "" : lx;
            string ss3 = string.IsNullOrEmpty(dw) ? "" : dw;
            var pp = bs_ItemService.ItemFenYeAsync(page, pageSize, ss,ss1,ss2,ss3);
            return Ok(pp);
        }

        [HttpGet]
        public async Task<FenYeUsers<GoodsInfo>> FindGoodsInfo(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemService.FindGoodsInfo(PageSize, CurrentPage, str);
        }

        [HttpPost]
        public async Task<bool> AddGoodsInfo(string item_name, string item_code, string item_type, string model_code, decimal inbill_price, decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, string ImgUrl)
        {
            return await bs_ItemService.AddGoodsInfo(item_name, item_code, item_type, model_code, inbill_price, outbill_price, sort_code, inbill_state, create_by, remark, unit, item_type_code, ImgUrl);
        }

        [HttpGet]
        public async Task<Bs_item_type> FindGoodsInfoById(string id)
        {
            return await bs_ItemService.FindGoodsInfoById(id);
        }

        [HttpGet]
        public async Task<GoodsInfo> FindGoodsIfoByItem_Id(int id)
        {
            return await bs_ItemService.FindGoodsIfoByItem_Id(id);
        }

        [HttpPut]
        public async Task<bool> UpdateGoodsInFO(string item_name, string item_code, string item_type, string model_code, decimal inbill_price, decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, int item_type_id, string ImgUrl)
        {
            return await bs_ItemService.UpdateGoodsInFO(item_name, item_code, item_type, model_code, inbill_price, outbill_price, sort_code, inbill_state, create_by, remark, unit, item_type_code, item_type_id, ImgUrl);
        }
        //[HttpGet]
        //public string[] FindGoodsIfoByItem_Id1(int id)
        //{

        //    //Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(id.ToString());
        //    //ArrayList y = new ArrayList(dictionaryDeserialized.Values);
        //    //List<Wh_orderbuy_dXX> w = JsonConvert.DeserializeObject<List<Wh_orderbuy_dXX>>(xx);
        //    //return await hh.InsertWh_inbill_hAsync(y, w);
        //    return bs_ItemService.FindGoodsIfoByItem_Id1(id);
        //}


        [HttpGet]
        public async Task<IEnumerable<PurchaseRecord>> FindPurchaseRecord(string item_code)
        {
            return await bs_ItemService.FindPurchaseRecord(item_code);
        }

        [HttpGet]
        public async Task<IEnumerable<Inventory>> FindWh_now_storage(string item_code)
        {
            return await bs_ItemService.FindWh_now_storage(item_code);
        }


        [HttpGet]
        public async Task<FenYeUsers<XiaoshouJL>> FindXiaoshouJl(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemService.FindXiaoshouJl(PageSize, CurrentPage, str);
        }

        [HttpGet]
        public async Task<FenYeUsers<InventoryRecords>> FindInventoryRecords(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemService.FindInventoryRecords(PageSize, CurrentPage, str);
        }

        [HttpGet]
        public async Task<FenYeUsers<TransferRecords>> FindTransferRecords(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemService.FindTransferRecords(PageSize, CurrentPage, str);
        }

        [HttpGet]
        public async Task<FenYeUsers<CkST>> FindCkSt(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemService.FindCkSt(PageSize, CurrentPage, str);
        }

        [HttpGet]

        public async Task<FenYeUsers<RkST>> FindRkst(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemService.FindRkst(PageSize, CurrentPage, str);
        }
       // [HttpGet]

        //public List<bs_item_type1> GetItems(string father_code)
        //{
        //    string query = "select item_type_code,item_type_name,father_code from BS_item_type WHERE father_code = @father_code";
        //    List<bs_item_type1> result = new List<bs_item_type1>();

        //    using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
        //    {
        //        using (SqlCommand command = new SqlCommand(query, connection))
        //        {
        //            command.Parameters.AddWithValue("@father_code", father_code);
        //            connection.Open();

        //            using (SqlDataReader reader = command.ExecuteReader())
        //            {
        //                while (reader.Read())
        //                {
        //                    bs_item_type1 menuItem = new bs_item_type1();
        //                    menuItem.item_type_code = reader.GetString(0).ToString();
        //                    menuItem.item_type_name = reader.GetString(1);
        //                    menuItem.children = GetItems(menuItem.item_type_code);
        //                    result.Add(menuItem);
        //                }
        //            }
        //        }
        //    }
        //    return result;
        //}


        [HttpGet]
        public List<bs_item_type1> GetItems1(int father_code)
        {

            string query = $"select item_type_code,item_type_name,father_code from BS_item_type WHERE father_code = @father_code";
            string zfc = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";

            List<bs_item_type1> result = new List<bs_item_type1>();

            using (SqlConnection connection = new SqlConnection(zfc))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                  //  command.Parameters.AddWithValue("@father_code", father_code);
                    int fatherCodeAsInt = int.Parse(father_code.ToString());
                    command.Parameters.AddWithValue("@father_code", fatherCodeAsInt);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            bs_item_type1 menuItem = new bs_item_type1();
                            menuItem.item_type_id = (int)reader.GetInt64(0);
                            menuItem.item_type_name = reader.GetString(1);
                            menuItem.children = GetItems1(menuItem.item_type_id);

                            result.Add(menuItem);
                        }
                    }
                }
            }

            return result;
        }

    }
}
