using AutoMapper;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Repository.Ku;

namespace WMS.AppService.AppService.Ku
{
    /// <summary>
    /// 库存盘点
    /// </summary>
    public class Wh_inventory_hAppService: IWh_inventory_hAppService
    {
        private readonly IWh_inventory_hRepository hh;
        private readonly IMapper mapper;
        public Wh_inventory_hAppService(IWh_inventory_hRepository hh, IMapper mapper)
        {
            this.hh = hh;
            this.mapper = mapper;
        }

        //添加盘点

        public Task<bool> InsertWh_inventory_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
        {
            return hh.InsertWh_inventory_hAsync(arrayList,xx);
        }
        //库存盘点分页
        public Task<Fen<ST22>> FenYE(int pageSize, int currentPage, string str)
        {
            return hh.FenYE(pageSize,currentPage,str);
        }
        //详细信息
        public Task<Wh_inventory_h> Wh_inventory_hMHAsync(string bh)
        {
            return hh.Wh_inventory_hMHAsync(bh);
        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Wh_inventory_dXX>> Wh_inventory_dMHAsync(string bh)
        {
            return await hh.Wh_inventory_dMHAsync(bh);
        }
        //修改盘点

        public async Task<bool> UpdateWh_inventory_hAsync(ArrayList arrayList, List<Wh_inventory_dXX> xx)
        {
            return await hh.UpdateWh_inventory_hAsync(arrayList,xx);
        }
        //审核
        public async Task<bool> Wh_inventory_hSHAsync(int zt, string name, string desc, string ii)
        {
            return await hh.Wh_inventory_hSHAsync(zt,name,desc,ii);
        }
        //删除调拨信息
        public async Task<bool> DeleteWh_inventory_hAsync(string dto)
        {
            return await hh.DeleteWh_inventory_hAsync((string)dto);
        }
        //批量删除调拨信息
        public async Task<bool> DeleteSWh_inventory_hAsync(int[] sz)
        {
            return await hh.DeleteSWh_inventory_hAsync(sz);
        }
    }
}
