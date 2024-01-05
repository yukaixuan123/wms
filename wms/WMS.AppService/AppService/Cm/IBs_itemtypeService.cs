using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.User;

namespace WMS.AppService.AppService.Cm
{
    public interface IBs_itemtypeService
    {
        //查询全部货品类型
        Task<List<Bs_item_type>> ItemTypesSelectAsync();
        //添加货品类型
        Task<bool> ItemTypesAddAsync(AddBs_itemtypeDtos addBs_ItemtypeDtos);
        //货品类型逻辑删除
        Task<bool> ItemTypesRemoveAsync(int id,string bl);
        //修改货品类型
        Task<bool> ItemTypesUpdateAsync(UpdateBs_itemtypeDtos updateBs_ItemtypeDtos);
        //货品类型模糊条件查询
        IEnumerable<Bs_item_type> ItemTypeMHAsync(string bh,string zt,string czr,string sj);
        //根据id查名称
        Task<string> SelectIdAsync(int id);
        //操作人下拉框
        Task<IEnumerable<Users>> CzrAsync();
        //批量删除
        Task<bool> PLDeleteItemType(int[] num);
        Task<Bs_item_type> ITSelectIDAsync(int id);


        //查询货品父级
        Task<IEnumerable<GoodsCascader>> fatherGoodsFind();


        //按id查询父级
        Task<IEnumerable<GoodsCascader>> fatherGoodsFindById(int id);   

        //查询全部

        public Task<FenYeUsers<Bs_item_type>> FindGoodsType(int pageSize, int CurrentPage, string str);

        //添加货品类型
        Task<bool> AddGoodsType(string father_code,string item_type_code,string item_type_name ,string inbill_state,int sort_code,string remark, string create_by,string is_del);

        //修改货品类型
        Task<bool> UpdateGoodsType(string father_code,string item_type_code,string item_type_name,string inbill_state,string sort_code,string remark,string update_by, int item_type_id);
    }
}
