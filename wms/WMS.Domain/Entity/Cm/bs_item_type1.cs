using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Cm
{
    public class bs_item_type1
    {
        public int item_type_id { get; set; }
        public string item_type_code { get; set; }//货品类型编号
        public string item_type_name { get; set; }//货品类型名称
        public int father_code { get; set; }//父节点
        public int sort_code { get; set; }//排序
        public string inbill_state { get; set; }//入库状态
        public string remark { get; set; }//备注
        public string create_by { get; set; }//操作人
        public DateTime create_time { get; set; }//操作时间
        public string update_by { get; set; }//更新者
        public DateTime? update_time { get; set; }//更新时间
        public string is_del { get; set; }//逻辑删除

        public List<bs_item_type1> children { get; set; }


    }
}
