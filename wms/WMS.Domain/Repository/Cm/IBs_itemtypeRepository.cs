using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.User;

namespace WMS.Domain.Repository.Cm
{
    public interface IBs_itemtypeRepository
    {
        //查询全部货品类型
        Task<List<Bs_item_type>> ItemTypeSelectAsync();
        //添加货品类型
        Task<bool> ItemTypeAddAsync(Bs_item_type itemType);
        //修改货品类型
        Task<bool> ItemTypeUpdateAsync(Bs_item_type itemType);
        //货品类型逻辑删除
        Task<bool> ItemTypeDeleteAsync(int id,string bl);
        //货品类型模糊条件查询
        IEnumerable<Bs_item_type> ItemTypeMHAsync(string bh,string zt,string czr,string sj);
        //根据id查名称
        Task<string> SelectIdAsync(int id);
        //操作人下拉框
        Task<IEnumerable<Users>> CzrAsync();
        //批量删除
        Task<bool> PLDeleteItemType(int[] num);
        //根据id查全部
        Task<Bs_item_type> ITSelectIDAsync(int id);


        Task<IEnumerable<GoodsCascader>> fatherGoodsFind();


        public Task<FenYeUsers<Bs_item_type>> FindGoodsType(int pageSize, int CurrentPage, string str);


        Task<bool> AddGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, int sort_code, string remark, string create_by, string is_del);

        Task<bool> UpdateGoodsType(string father_code, string item_type_code, string item_type_name, string inbill_state, string sort_code, string remark, string update_by, int item_type_id);

        Task<IEnumerable<GoodsCascader>> fatherGoodsFindById(int id);
    }
}
