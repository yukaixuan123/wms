using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Drawing;
using WMS.AppService.AppService.Bs;
using WMS.AppService.Dtos.Bs;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.EFCore;
using WMS.EFCore.Repository.Bs;

namespace WMS.Controllers.Bs
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Bs_warehouseController : ControllerBase
    {
        private readonly IBs_warehouseAppService bs_WarehouseAppService;
        public Bs_warehouseController(IBs_warehouseAppService bs_WarehouseAppService)
        {
            this.bs_WarehouseAppService = bs_WarehouseAppService;
        }
        [HttpGet]
        public async Task<List<Bs_warehouse>> Bs_warehouseSelect()
        {
            return await bs_WarehouseAppService.Bs_warehouseSelect();
        }
        [HttpGet]
        public async Task<List<Bs_warehouse>> Bs_warehouseSelect1()
        {
            return await bs_WarehouseAppService.Bs_warehouseSelect1();
        }

        [HttpPost]
        public async Task<bool> Bs_warehouseAdd(AddBs_warehouseDto addBs_WarehouseDto)
        {
            return await bs_WarehouseAppService.Bs_warehouseAdd(addBs_WarehouseDto);
        }

        [HttpDelete]
        public async Task<int> Bs_warehouseDel(DelBs_warehouseDto delBs_WarehouseDto)
        {
            return await bs_WarehouseAppService.Bs_warehouseDel(delBs_WarehouseDto);
        }

        [HttpPut]
        public async Task<bool> Bs_warehouseUpdate(UpdateBs_warehouseDto updateBs_WarehouseDto)
        {
            return await bs_WarehouseAppService.Bs_warehouseUpdate(updateBs_WarehouseDto);
        }
        [HttpGet]
        public IEnumerable<Bs_warehouse> Bs_WarehousesFenYe(int paga, int size)
        {
            return bs_WarehouseAppService.Bs_warehouseFenYe(paga, size);
        }

        [HttpGet]
        public IActionResult Bs_WarehousesMH(string bh = "",string zt = "", string zg = "")
        {
            string BH = string.IsNullOrEmpty(bh) ? "" : bh;
            string ZT = string.IsNullOrEmpty(zt) ? "" : zt;
            string ZG = string.IsNullOrEmpty(zg) ? "" : zg;
            var products = bs_WarehouseAppService.Bs_WarehousesMH(BH, ZT, ZG);
            return Ok(products);
        }
        [HttpGet]
        public IActionResult Bs_WarehouseFYMH(int page, int size, string bh = "", string zt = "", string zg = "")
        {
            string BH = string.IsNullOrEmpty(bh) ? "" : bh;
            string ZT = string.IsNullOrEmpty(zt) ? "" : zt;
            string ZG = string.IsNullOrEmpty(zg) ? "" : zg;

            var products = bs_WarehouseAppService.Bs_WarehouseFYMH(page, size, BH,ZT,ZG);

            return Ok(products);
        }
        [HttpPut]
        public async Task<bool> Bs_WarehouseRKDel(int id, string del)
        {
            return await bs_WarehouseAppService.Bs_WarehouseRKDel(id, del);
        }

        [HttpPost]
        public async Task<FenYeSupply<CKView>> FenYeHouseAsync(int currentPage, int pageSize, string str)
        {
            return await bs_WarehouseAppService.FenYeHouseAsync(currentPage, pageSize, str);
        }
        [HttpGet]
        public async Task<int> SelectAreaSLAsync(string name)
        {
            return await bs_WarehouseAppService.SelectAreaSLAsync(name);
        }
        [HttpPost]
        public async Task<bool> InsertHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string cz, string gx, string name, string bz, string dh)
        {
            return await bs_WarehouseAppService.InsertHouseAsync(code, cap, zt, adr, mr, sd, man, px, cz, gx, name, bz, dh);
        }
        [HttpGet]
        public async Task<int> SelectNameAsync(string name)
        {
            return await bs_WarehouseAppService.SelectNameAsync(name);
        }
        [HttpPut]
        public async Task<bool> UpdateSDAsync()
        {
            return await bs_WarehouseAppService.UpdateSDAsync();
        }
        [HttpGet]
        public async Task<Bs_warehouse> SelectIDAsync(int id)
        {
            return await bs_WarehouseAppService.SelectIDAsync(id);
        }
        [HttpPut]
        public async Task<bool> UpdateHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string gx, string name, string bz, string dh, int id)
        {
            return await bs_WarehouseAppService.UpdateHouseAsync(code, cap, zt, adr, mr, sd, man, px, gx, name, bz, dh, id);
        }
        [HttpPost]
        public async Task<bool> DeleteHouseAsync(int id, string str)
        {
            return await bs_WarehouseAppService.DeleteHouseAsync(id, str);
        }
        [HttpPut]
        public async Task<bool> PLDeleteHouse([FromBody] int[] num)
        {
            return await bs_WarehouseAppService.PLDeleteHouse(num);
        }
        [HttpGet]
        public async Task<CKView> SelectCodeAsync(string id)
        {
            return await bs_WarehouseAppService.SelectCodeAsync(id);
        }
        [HttpPut]
        public async Task<bool> PLQiHouse([FromBody] int[] num)
        {
            return await bs_WarehouseAppService.PLQiHouse(num);
        }
        [HttpPut]
        public async Task<bool> PLTingHouse([FromBody] int[] num)
        {
            return await bs_WarehouseAppService.PLTingHouse(num);
        }
    }
}
