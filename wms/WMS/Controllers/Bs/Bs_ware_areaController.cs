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
    public class Bs_ware_areaController : ControllerBase
    {
        private readonly IBs_ware_areaAppService bs_Ware_AreaAppService;
        public Bs_ware_areaController(IBs_ware_areaAppService bs_Ware_AreaAppService)
        {
            this.bs_Ware_AreaAppService = bs_Ware_AreaAppService;
        }
        [HttpGet]
        public async Task<List<Bs_ware_area>> Bs_ware_areaSelect()
        {
            return await bs_Ware_AreaAppService.Bs_ware_areaSelect();
        }

        [HttpPost]
        public async Task<bool> Bs_ware_areaAdd(AddBs_ware_areaDto addBs_ware_areaDto)
        {
            return await bs_Ware_AreaAppService.Bs_ware_areaAdd(addBs_ware_areaDto);
        }

        [HttpDelete]
        public async Task<int> Bs_ware_areaDel(DelBs_ware_areaDto delBs_ware_areaDto)
        {
            return await bs_Ware_AreaAppService.Bs_ware_areaDel(delBs_ware_areaDto);
        }

        [HttpPut]
        public async Task<bool> Bs_ware_areaeUpdate(UpdateBs_ware_areaDto updateBs_ware_areaDto)
        {
            return await bs_Ware_AreaAppService.Bs_ware_areaUpdate(updateBs_ware_areaDto);
        }
        [HttpGet]
        public IEnumerable<Bs_ware_area> Bs_ware_areaFenYe(int paga, int size)
        {
            return bs_Ware_AreaAppService.Bs_ware_areaFenYe(paga, size);
        }
        [HttpPut]
        public async Task<bool> Bs_ware_areaRKDel(int id, string del)
        {
            return await bs_Ware_AreaAppService.Bs_ware_areaRKDel(id, del);
        }
        [HttpPost]
        public async Task<FenYeSupply<Bs_ware_area>> FenYeWareAreaAsync(int currentPage, int pageSize, string str)
        {
            return await bs_Ware_AreaAppService.FenYeWareAreaAsync(currentPage, pageSize, str);
        }
        [HttpPost]
        public async Task<bool> InsertAreaAsync(string code, string name, string cap, string man, int px, int zt, string cz, string gx, string bz, string dh,string cc)
        {
            return await bs_Ware_AreaAppService.InsertAreaAsync(code, name, cap, man, px, zt, cz, gx, bz, dh,cc);
        }
        [HttpGet]
        public async Task<Bs_ware_area> SelectIDAsync(int id)
        {
            return await bs_Ware_AreaAppService.SelectIDAsync(id);
        }
        [HttpPut]
        public async Task<bool> UpdateAreaAsync(string code, string name, string cap, string man, string px, string zt, string gx, string bz, string dh, string id,string cc)
        {
            return await bs_Ware_AreaAppService.UpdateAreaAsync(code, name, cap, man, px, zt, gx, bz, dh, id,cc);
        }
        [HttpGet]
        public async Task<int> AreaNameAsync(string name)
        {
            return await bs_Ware_AreaAppService.AreaNameAsync(name);
        }
        [HttpPost]
        public async Task<bool> AreaDeleteAsync(int id, string str)
        {
            return await bs_Ware_AreaAppService.AreaDeleteAsync(id, str);
        }
        [HttpPut]
        public async Task<bool> PLDeleteArea([FromBody] int[] num)
        {
            return await bs_Ware_AreaAppService.PLDeleteArea(num);
        }
    }
}
