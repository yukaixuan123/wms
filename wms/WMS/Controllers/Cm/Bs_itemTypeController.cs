using Microsoft.AspNetCore.Mvc;
using WMS.AppService.AppService.Cm;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Repository.Cm;
using WMS.EFCore.Repository.Cm;

namespace WMS.Controllers.Cm
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Bs_itemTypeController : ControllerBase
    {
        private readonly IBs_itemtypeService bs_ItemtypeService;
        public Bs_itemTypeController(IBs_itemtypeService bs_ItemtypeService)
        {
            this.bs_ItemtypeService = bs_ItemtypeService;
        }
        [HttpGet]
        public async Task<List<Bs_item_type>> Bs_ItemTypesSelectAsync()
        {
            return await bs_ItemtypeService.ItemTypesSelectAsync();
        }
        [HttpPost]
        public async Task<bool> Bs_ItemTypesAddAsync(AddBs_itemtypeDtos addBs_ItemtypeDtos)
        {
            return await bs_ItemtypeService.ItemTypesAddAsync(addBs_ItemtypeDtos);
        }
        [HttpPut]
        public async Task<bool> Bs_ItemTypesUpdateAsync(UpdateBs_itemtypeDtos updateBs_ItemtypeDtos)
        {
            return await bs_ItemtypeService.ItemTypesUpdateAsync(updateBs_ItemtypeDtos);
        }
        [HttpDelete]
        public async Task<bool> Bs_ItemTypesDeleteAsync(int id,string bl)
        {
            return await bs_ItemtypeService.ItemTypesRemoveAsync(id, bl);
        }
        [HttpGet]
        public IActionResult MH(string bh = "",string zt = "",string czr = "",string sj = "")
        {
            string ss = string.IsNullOrEmpty(bh) ? "" : bh;
            string ss1 = string.IsNullOrEmpty(zt) ? "" : zt;
            string ss2 = string.IsNullOrEmpty(czr) ? "" : czr;
            string ss3 = string.IsNullOrEmpty(sj) ? "" : sj;
            var pp= bs_ItemtypeService.ItemTypeMHAsync(ss,ss1,ss2,ss3);
            return Ok(pp);
        }

        [HttpGet]

        public async Task<IEnumerable<GoodsCascader>> fatherGoodsFind()
        {
            return await bs_ItemtypeService.fatherGoodsFind();
        }

        [HttpGet]
        public async Task<FenYeUsers<Bs_item_type>> FindGoodsType(int pageSize, int CurrentPage, string str)
        {
            return await bs_ItemtypeService.FindGoodsType(pageSize, CurrentPage, str);
        }
        [HttpPut]
        /// <summary>
        /// 货品类型批量删除
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> PLDeleteItemType([FromBody] int[] num)
        {
            return await bs_ItemtypeService.PLDeleteItemType(num);
        }

        [HttpPost]
        public async Task<bool> AddGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, int sort_code, string remark, string create_by, string is_del)
        {
            return await bs_ItemtypeService.AddGoodsType(father_code, item_type_code, item_type_name, inbill_state, sort_code, remark, create_by, is_del);
        }

        [HttpPut]
        public async Task<bool> UpdateGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, string sort_code, string remark, string update_by, int item_type_id)
        {
            return await bs_ItemtypeService.UpdateGoodsType(father_code, item_type_code, item_type_name, inbill_state, sort_code, remark, update_by, item_type_id);
        }

        [HttpGet]
        public async Task<IEnumerable<GoodsCascader>> fatherGoodsFindById(int id)
        {
            return await bs_ItemtypeService.fatherGoodsFindById(id);
        }
    }
}
