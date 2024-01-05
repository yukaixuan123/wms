using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 销售明细表
    /// </summary>
    internal class Wh_sale_dConfiger : IEntityTypeConfiguration<Wh_sale_d>
    {
        public void Configure(EntityTypeBuilder<Wh_sale_d> builder)
        {
            builder.ToTable(nameof(Wh_sale_d));
            builder.HasKey(e => e.sale_codeId);
            builder.Property(e => e.sale_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.model_code).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.unit).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.item_type_name).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.inbill3_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.return_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.outbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.sale_price).HasColumnType("decimal(18,2)").IsRequired();
        }
    }
}
