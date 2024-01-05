using AutoMapper;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Ku;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Ku;

namespace WMS.AppService.AppService.Ku
{
    /// <summary>
    /// 入库管理
    /// </summary>
    public class Wh_inbill_hAppService : IWh_inbill_hAppService
    {
        private readonly IWh_inbill_hRepository hh;
        private readonly IMapper mapper;
        public Wh_inbill_hAppService(IWh_inbill_hRepository hh, IMapper mapper)
        {
            this.hh = hh;
            this.mapper = mapper;
        }
        /// <summary>
        /// 添加入库信息
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> AddWh_inbill_hAsync(AddWh_inbill_hDto dto)
        {
            Wh_inbill_h wh = mapper.Map<Wh_inbill_h>(dto);
            return hh.AddWh_inbill_hAsync(wh);
        }
        //货品分页

        public async Task<Fen<Bb_view>> HP(int pageSize, int currentPage, string str)
        {
            return await hh.HP(pageSize, currentPage, str);
        }
        /// <summary>
        /// 仓位
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<List<Bs_ware_area>> Bs_ware_areaName(string id)
        {
           return hh.Bs_ware_areaName(id);
        }
        /// <summary>
        /// 供应商
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_supply>> Bs_supplyFind()
        {
            return hh.Bs_supplyFind();
        }
        public Task<Bs_supply> Bs_supplyName(string name)
        {
            return hh.Bs_supplyName(name);
        }
        /// <summary>
        /// 批量删除入库信息
        /// </summary>
        /// <param name="sz"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> DeleteSWh_inbill_hAsync(int[] sz)
        {
            return hh.DeleteSWh_inbill_hAsync(sz);
        }


        /// <summary>
        /// 删除入库信息
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> DeleteWh_inbill_hAsync(int dto)
        {
           
            return hh.DeleteWh_inbill_hAsync(dto);
        }
        /// <summary>
        /// 添加入库
        /// </summary>
        /// <param name="list"></param>
        /// <param name="list1"></param>
        /// <returns></returns>
        public Task<bool> InsertWh_inbill_hAsync(ArrayList list, List<Wh_orderbuy_dXX> xx)
        {
            return hh.InsertWh_inbill_hAsync(list, xx);
        }
        public Task<Fen<ST>> FenYE(int pageSize, int currentPage, string str)
        {
            return hh.FenYE(pageSize, currentPage, str);
        }

        /// <summary>
        /// 修改入库信息
        /// </summary>
        /// <param name="dto"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> UpdateWh_inbill_hAsync(UpdateWh_inbill_hDto dto)
        {
            Wh_inbill_h wh = mapper.Map<Wh_inbill_h>(dto);
            return hh.UpdateWh_inbill_hAsync(wh);
        }
        /// <summary>
        /// 用户
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<List<Users>> UserFind()
        {
           return hh.UserFind();
        }

        /// <summary>
        /// 进货订单
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<Fen<View>> Wh_buy_order_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            return hh.Wh_buy_order_hFenYeAsync (pageSize, currentPage, str);
        }

        /// <summary>
        /// 分页模糊查询
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="bh"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<FenYe<Wh_inbill_h>> Wh_inbill_hAsync(int page, int pageSize, string bh, string lx, string zt, string ck)
        {
           return hh.Wh_inbill_hAsync(page, pageSize, bh,lx,zt,ck);
        }

        /// <summary>
        /// 分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>

        public IEnumerable<Wh_inbill_h> Wh_inbill_hFenYeAsync(int page, int pageSize)
        {
           return hh.Wh_inbill_hFenYeAsync(page,pageSize );
        }
        /// <summary>
        /// 模糊查询
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public Task<Wh_inbill_h> Wh_inbill_hMHAsync(string bh)
        {
            return hh.Wh_inbill_hMHAsync(bh);
        }

        //当前用户
        public async Task<Users> UsersID(string username, string password)
        {
            return await hh.UsersID(username, password);
        }
        //审核
        public Task<bool> Wh_inbill_hSHAsync(int zt, string name, int id, string desc, string ii)
        {
            return hh.Wh_inbill_hSHAsync (zt, name, id,desc,ii);
        }

        //添加库存
        public async Task<bool> Wh_now_storageAsync(string dh)
        {
            return await hh.Wh_now_storageAsync (dh);
        }

        //撤销
        public async Task<bool> Wh_inbill_hCXAsync(string name, string ii)
        {
            return await hh.Wh_inbill_hCXAsync(name, ii);
        }
        /// <summary>
        /// 查询全部
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<List<Wh_inbill_h>> Wh_inbill_hSelectAsync()
        {
            return hh.Wh_inbill_hSelectAsync();
        }
        //入库单号查明细
        public async Task<List<Wh_inbill_dXX>> Wh_inbill_dMHAsync(string bh)
        {
            return await hh.Wh_inbill_dMHAsync(bh);
        }
        public Task<Fen<Wh_orderbuy_dXX>> Wh_orderbuy_dBH(int pageSize, int currentPage, string str)
        {
           return hh.Wh_orderbuy_dBH(pageSize, currentPage, str);
        }


        //添加入库 没有关联单号
        public async Task<bool> Insert1Wh_inbill_hAsync(ArrayList arrayList, List<Wh_orderbuy_dXX> xx)
        {
            return await hh.Insert1Wh_inbill_hAsync(arrayList, xx);
        }
        //修改入库（没有关联单号）
        public async Task<bool> Update1Wh_inbill_hAsync(ArrayList arrayList, List<Wh_inbill_dXX> xx)
        {
            return await hh.Update1Wh_inbill_hAsync(arrayList, xx);
        }
        //修改入库(有关联订单)

        public async Task<bool> Update2Wh_inbill_hAsync(ArrayList arrayList, List<Wh_inbill_dXX> xx)
        {
            return await hh.Update2Wh_inbill_hAsync(arrayList, xx);
        }
        //审核记录的分页
        public async Task<Fen<Audit>> AuditFenYeAsync(int pageSize, int currentPage, string str)
        {
            return await hh.AuditFenYeAsync(pageSize, currentPage, str);
        }
    }
}
