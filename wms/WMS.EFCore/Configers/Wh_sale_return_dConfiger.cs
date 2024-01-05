using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 退货材料明细
    /// </summary>
    internal class Wh_sale_return_dConfiger : IEntityTypeConfiguration<Wh_sale_return_d>
    {
        public void Configure(EntityTypeBuilder<Wh_sale_return_d> builder)
        {
            builder.ToTable(nameof(Wh_sale_return_d));
            builder.HasKey(e => e.sr_codeId);
            builder.Property(e => e.sr_code).HasColumnType("char(16)").IsRequired();
           
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.inbill3_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.return_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.ware_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.area_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.batch_no).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sale_price).HasColumnType("decimal(18,2)").IsRequired();


        }
    }
}
