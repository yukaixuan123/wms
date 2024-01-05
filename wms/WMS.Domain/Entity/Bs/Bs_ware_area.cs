using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Bs
{
    public class Bs_ware_area   //库位信息表
    {
        public int ware_area_id { get; set; }
        public string area_code { get; set; }//库位编号
        public string area_name { get; set;}//库位名称
        public int area_cap { get; set; }//库位容量/立方
        public string area_duty_man { get; set; }//仓位主管
        public int sort_code { get; set; }//排序
        public string area_state { get; set; }//库位状态
        public string create_by { get; set; }//操作人
        public DateTime create_time { get; set; }//操作时间
        public DateTime update_time { get; set;}//更新时间
        public string update_by { get; set;}//更新者
        public string is_del { get; set; }//逻辑删除
        public string warehouse_id { get; set; }
        public string dh { get; set; }
        public string remark { get; set; }
    }
}
