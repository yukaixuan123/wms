using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;

namespace WMS.Domain.Repository.Ku
{
    public interface IWh_inbill_hRepository
    {
        //查询全部
        public Task<List<Wh_inbill_h>> Wh_inbill_hSelectAsync();
        //分页

        IEnumerable<Wh_inbill_h> Wh_inbill_hFenYeAsync(int page, int pageSize);

        //模糊查询
       public  Task<Wh_inbill_h> Wh_inbill_hMHAsync(string bh);
        //入库单号查明细
        public Task<List<Wh_inbill_dXX>> Wh_inbill_dMHAsync(string bh);
        //分页模糊查询
        Task<FenYe<Wh_inbill_h>> Wh_inbill_hAsync(int page, int pageSize, string bh, string lx, string zt, string ck);

        //添加入库信息
        public Task<bool> AddWh_inbill_hAsync(Wh_inbill_h dto);
        //修改入库信息
        public Task<bool> UpdateWh_inbill_hAsync(Wh_inbill_h dto);
        //删除入库信息
        public Task<bool> DeleteWh_inbill_hAsync(int dto);

        public Task<Fen<ST>> FenYE(int pageSize, int currentPage, string str);

        //进货订单
        public Task<Fen<View>> Wh_buy_order_hFenYeAsync(int pageSize, int currentPage, string str);
        //用户
        public Task<List<Users>> UserFind();
        //详细详细

        public Task<Fen<Wh_orderbuy_dXX>> Wh_orderbuy_dBH(int pageSize, int currentPage, string str);
        //仓位
        public Task<List<Bs_ware_area>> Bs_ware_areaName(string id);
        //批量删除入库信息
        public Task<bool> DeleteSWh_inbill_hAsync(int[] sz);
        //供应商

        public Task<List<Bs_supply>> Bs_supplyFind();
        //添加入库
        public Task<bool> InsertWh_inbill_hAsync(ArrayList list, List<Wh_orderbuy_dXX> xx);
        //根据名字找供应商
        public Task<Bs_supply> Bs_supplyName(string name);
        //货品分页

        public Task<Fen<Bb_view>> HP(int pageSize, int currentPage, string str);
        //添加入库 没有关联单号
        public Task<bool> Insert1Wh_inbill_hAsync(ArrayList arrayList, List<Wh_orderbuy_dXX> xx);
        //当前用户
        public Task<Users> UsersID(string username, string password);
        //审核
        public Task<bool> Wh_inbill_hSHAsync(int zt, string name, int id, string desc,string ii);
        //修改入库（没有关联单号）
        public  Task<bool> Update1Wh_inbill_hAsync(ArrayList arrayList, List<Wh_inbill_dXX> xx);
        //审核记录的分页
        public  Task<Fen<Audit>> AuditFenYeAsync(int pageSize, int currentPage, string str);

        //添加库存
        public  Task<bool> Wh_now_storageAsync(string dh);

        //撤销
        public Task<bool> Wh_inbill_hCXAsync(string name, string ii);

        //修改入库(有关联订单)

        public  Task<bool> Update2Wh_inbill_hAsync(ArrayList arrayList, List<Wh_inbill_dXX> xx);
    }
}
