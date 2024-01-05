using AutoMapper;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Repository.Ku;

namespace WMS.AppService.AppService.Ku
{
    /// <summary>
    /// 出库管理
    /// </summary>
   public class Wh_outbill_hAppService: IWh_outbill_hAppService
    {
        private readonly IWh_outbill_hRepository hh;
       
        public Wh_outbill_hAppService(IWh_outbill_hRepository hh)
        {
            this.hh = hh;
          
        }
        //客户
        public Task<List<Bs_customer>> Bs_customerFind()
        {
            return hh.Bs_customerFind();
        }
        //根据名字找客户
        public Task<Bs_customer> Bs_customerName(string name)
        {
            return hh.Bs_customerName(name);
        }
        /// <summary>
        /// 有库存的仓库
        /// </summary>
        /// <returns></returns>
        public Task<List<string>> Ku(int id)
        {
            return hh.Ku(id);
        }
        public Task<List<string>> Ku1()
        {
            return hh.Ku1();    
        }
        /// <summary>
        /// 有库存的货品
        /// </summary>
        /// <returns></returns>
        public Task<string[]> Hp(string ck)
        {
            return hh.Hp(ck);
        }
        /// <summary>
        /// 对应货品的库存
        /// </summary>
        /// <param name="hp"></param>
        /// <param name="kw"></param>
        /// <returns></returns>
        public Task<Wh_now_storage> Num(string hp, string kw)
        {
            return hh.Num(hp, kw);
        }
        //出库管理分页
        public Task<Fen<ST11>> FenYE(int pageSize, int currentPage, string str)
        {
            return hh.FenYE(pageSize, currentPage, str);
        }
        //添加出库(没有关联订单)

        public async Task<bool> Insert1Wh_outbill_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
        {
            return await hh.Insert1Wh_outbill_hAsync(arrayList, xx);
        }

        //销售订单分页
        public Task<Fen<View_Sale>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            return hh.Wh_sale_hFenYeAsync(pageSize, currentPage, str);
        }

        /// <summary>
        /// 销售订单详细
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<List<Wh_sale_dXX>> Wh_sale_BH(string str)
        {
            return await hh.Wh_sale_BH(str);
        }
        /// <summary>
        /// 添加入库（没有关联单号）
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        public Task<bool> InsertWh_outbill_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
        {
           return hh.InsertWh_outbill_hAsync((ArrayList)arrayList, xx);
        }

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Wh_outbill_dXX>> Wh_outbill_dMHAsync(string bh)
        {
            return await hh.Wh_outbill_dMHAsync(bh);
        }
        //详细信息
        public async Task<Wh_outbill_h> Wh_outbill_hMHAsync(string bh)
        {
            return await hh.Wh_outbill_hMHAsync(bh);
        }
        //修改出库(没有关联订单)

        public async Task<bool> Update1Wh_outbill_hAsync(ArrayList arrayList, List<Wh_outbill_dXX> xx)
        {
            return await hh.Update1Wh_outbill_hAsync(arrayList, xx);
        }
        //修改出库(有关联订单)

        public async Task<bool> Update2Wh_outbill_hAsync(ArrayList arrayList, List<Wh_outbill_dXX> xx)
        {
            return await hh.Update2Wh_outbill_hAsync (arrayList, xx);
        }
        //审核
        public async Task<bool> Wh_outbill_hSHAsync(int zt, string name, string desc, string ii)
        {
            return await hh.Wh_outbill_hSHAsync (zt, name, desc, ii);
        }
        //改变库存
        public async Task<bool> Wh_now_storageAsync(string dh)
        {
            return await hh.Wh_now_storageAsync (dh);
        }

        //删除出库信息
        public async Task<bool> DeleteWh_outbill_hAsync(string dto)
        {
            return await hh.DeleteWh_outbill_hAsync(dto);
        }
        //批量删除出库信息
        public async Task<bool> DeleteSWh_outbill_hAsync(int[] sz)
        {
            return await hh.DeleteSWh_outbill_hAsync(sz);
        }
        /// <summary>
        /// 根据名字找仓库
        /// </summary>
        /// <returns></returns>
        public Task<Bs_warehouse> Bs_warehouseName(string name)
        {
            return hh.Bs_warehouseName (name);
        }
    }
}
