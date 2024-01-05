using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Cm;

namespace WMS.AppService.AppService.Cm
{
    public class Bs_itemtypeService : IBs_itemtypeService
    {
        private readonly IBs_itemtypeRepository bs_ItemtypeRepository;
        private readonly IMapper mapper;
        public Bs_itemtypeService(IBs_itemtypeRepository bs_itemtypeRepository, IMapper mapper)
        {
            this.bs_ItemtypeRepository = bs_itemtypeRepository;
            this.mapper = mapper;
        }
        /// <summary>
        /// 添加货品类型
        /// </summary>
        /// <param name="addBs_ItemtypeDtos"></param>
        /// <returns></returns>
        public Task<bool> ItemTypesAddAsync(AddBs_itemtypeDtos addBs_ItemtypeDtos)
        {
            Bs_item_type bs_Item_Type = mapper.Map<Bs_item_type>(addBs_ItemtypeDtos);
            return bs_ItemtypeRepository.ItemTypeAddAsync(bs_Item_Type);
        }
        /// <summary>
        /// 货品类型逻辑删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        public Task<bool> ItemTypesRemoveAsync(int id,string bl)
        {
            return bs_ItemtypeRepository.ItemTypeDeleteAsync(id, bl);
        }
        /// <summary>
        /// 查询全部货品类型
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_item_type>> ItemTypesSelectAsync()
        {
            return bs_ItemtypeRepository.ItemTypeSelectAsync();
        }
        /// <summary>
        /// 修改货品类型
        /// </summary>
        /// <param name="updateBs_ItemtypeDtos"></param>
        /// <returns></returns>
        public Task<bool> ItemTypesUpdateAsync(UpdateBs_itemtypeDtos updateBs_ItemtypeDtos)
        {
            Bs_item_type bs_Item_Type = mapper.Map<Bs_item_type>(updateBs_ItemtypeDtos);
            return bs_ItemtypeRepository.ItemTypeUpdateAsync(bs_Item_Type);
        }
        /// <summary>
        /// 货品类型模糊条件查询
        /// </summary>
        /// <param name="bh">编号</param>
        /// <param name="zt">状态</param>
        /// <param name="czr">操作人</param>
        /// <param name="sj">时间</param>
        /// <returns></returns>
        public IEnumerable<Bs_item_type> ItemTypeMHAsync(string bh,string zt,string czr,string sj)
        {
           return bs_ItemtypeRepository.ItemTypeMHAsync(bh,zt,czr,sj);
        }
        /// <summary>
        /// 根据id查名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public Task<string> SelectIdAsync(int id)
        {
            return bs_ItemtypeRepository.SelectIdAsync(id);
        }
        /// <summary>
        /// 操作人下拉框
        /// </summary>
        /// <returns></returns>
        public Task<IEnumerable<Users>> CzrAsync()
        {
            return bs_ItemtypeRepository.CzrAsync();
        }
        /// <summary>
        /// 货品类型批量删除
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> PLDeleteItemType(int[] num)
        {
            return bs_ItemtypeRepository.PLDeleteItemType(num);
        }

        public Task<Bs_item_type> ITSelectIDAsync(int id)
        {
            return bs_ItemtypeRepository.ITSelectIDAsync(id);
        }

        public async Task<IEnumerable<GoodsCascader>> fatherGoodsFind()
        {
           return await bs_ItemtypeRepository.fatherGoodsFind();
        }

        public async Task<FenYeUsers<Bs_item_type>> FindGoodsType(int pageSize, int CurrentPage, string str)
        {
            return await bs_ItemtypeRepository.FindGoodsType(pageSize, CurrentPage, str);
        }

        public async Task<bool> AddGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, int sort_code, string remark, string create_by, string is_del)
        {
            return await bs_ItemtypeRepository.AddGoodsType(father_code,item_type_code,item_type_name,inbill_state,sort_code,remark,create_by,is_del);
        }

        public async Task<bool> UpdateGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, string sort_code, string remark, string update_by,int item_type_id)
        {
            return await bs_ItemtypeRepository.UpdateGoodsType(father_code, item_type_code, item_type_name, inbill_state, sort_code, remark, update_by, item_type_id);
        }

        public async Task<IEnumerable<GoodsCascader>> fatherGoodsFindById(int id)
        {
            return await bs_ItemtypeRepository.fatherGoodsFindById(id);
        }
    }
}
