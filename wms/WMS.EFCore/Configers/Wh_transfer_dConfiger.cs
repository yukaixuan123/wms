using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 调拨明细表
    /// </summary>
    internal class Wh_transfer_dConfiger : IEntityTypeConfiguration<Wh_transfer_d>
    {
        public void Configure(EntityTypeBuilder<Wh_transfer_d> builder)
        {
            builder.ToTable(nameof(Wh_transfer_d));
            builder.HasKey(e => e.transfer_d_id);
            builder.Property(e => e.transfer_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.wh__transfer_code).HasColumnType("char(16)").IsRequired(false);
            builder.Property(e => e.item_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.model_code).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.unit).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.outarea_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.inarea_code).HasColumnType("char(6)").IsRequired(false);
            builder.Property(e => e.out_num);
            builder.Property(e => e.in_num);
            builder.Property(e => e.inbill_price).HasColumnType("decimal(18,2)").IsRequired();
        }
    }
}
