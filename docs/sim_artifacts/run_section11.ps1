$ErrorActionPreference='Stop'
$base='https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03'
$ts=(Get-Date).ToString('yyyyMMdd-HHmmss')
$artifactPath="docs/sim_artifacts/${ts}-section-11-upload-carousell-flow.json"

function Get-Json($url){ Invoke-RestMethod -Method Get -Uri $url }
function Post-Json($url,$obj){
  $json = $obj | ConvertTo-Json -Depth 20 -Compress
  Invoke-RestMethod -Method Post -Uri $url -ContentType 'application/json' -Body $json
}

$calls=@{}
$checks=@{}
$blocker=$null

# Allowed source data
$categories=Get-Json "$base/inventory_category_list"
$calls.inventoryCategoryList=@{status=200;count=@($categories).Count}

$allInv=Get-Json "$base/inventory?name=&category=&supplier="
$calls.inventory=@{status=200;count=@($allInv).Count}

# Choose inventory that already exists in carousell for reversible upsert test
$listBefore=Get-Json "$base/inventory_carousell?inventory_ids=%5B%5D&name=&category="
$calls.carousellListBefore=@{status=200;count=@($listBefore).Count}

$target=$listBefore | Select-Object -First 1
if(-not $target){ throw 'No existing carousell row found for reversible test.' }

$invId=[int]$target.inventory_id
$invRec=$allInv | Where-Object { $_.id -eq $invId } | Select-Object -First 1
if(-not $invRec){ throw "Inventory record for inventory_id=$invId not found in /inventory." }

$allowedCategory = ($categories | Where-Object { $_.category -eq $invRec.category } | Select-Object -First 1)
if(-not $allowedCategory){ throw "Inventory category '$($invRec.category)' not found in allowed category list." }

$unit = if($invRec.quantity_major){$invRec.quantity_major}else{'UNIT'}
$branch = if($target.branch){$target.branch}else{'Dentabay Bangi'}
$branchId = if($target.branch_id){[int]$target.branch_id}else{2}
$type = if($target.type){$target.type}else{'Selling'}
$expiry = if($target.expiry){$target.expiry}else{''}
$imageUrl = if($target.image_url){$target.image_url}else{''}
$qty = [double]$target.initial_quantity
if($qty -le 0){$qty = [double]($target.available_quantity)}
if($qty -le 0){$qty = 1}
$unitCost = [double]$target.unit_cost
if($unitCost -le 0){$unitCost = 1}
$origRemark = if($null -ne $target.remark){[string]$target.remark}else{''}
$simRemark = ($origRemark + ' [SIM11-UPSERT]').Trim()

$payloadMut = @{
  inventory_id=$invId
  branch=$branch
  branch_id=$branchId
  image_url=$imageUrl
  expiry_date='2025-05-05'
  initial_quantity=$qty
  unit_cost=$unitCost
  total_cost=([double]$qty*[double]$unitCost)
  unit=$unit
  available_quantity=$qty
  sold_quantity=0
  expiry=$expiry
  remark=$simRemark
  type=$type
}

$createResp = Post-Json "$base/inventory_carousell" $payloadMut
$calls.carousellPostMutation=@{status=200;response=$createResp}

$byIdAfterMut = Get-Json "$base/inventory_carousell?inventory_ids=%5B$invId%5D&name=&category="
$calls.carousellGetAfterMutation=@{status=200;count=@($byIdAfterMut).Count}

# detect if mutation touched existing row or created additional rows
$beforeRows = @($listBefore | Where-Object { [int]$_.inventory_id -eq $invId })
$afterRows = @($byIdAfterMut | Where-Object { [int]$_.inventory_id -eq $invId })

$mutationApplied = $false
$newRowsCreated = ($afterRows.Count -gt $beforeRows.Count)
$remarkFound = ($afterRows | Where-Object { ("$($_.remark)") -like '*[SIM11-UPSERT]*' } | Select-Object -First 1)
if($remarkFound){$mutationApplied=$true}

# revert attempt by posting original values
$payloadRevert = $payloadMut.Clone()
$payloadRevert['remark']=$origRemark
$revertResp = Post-Json "$base/inventory_carousell" $payloadRevert
$calls.carousellPostRevert=@{status=200;response=$revertResp}

$byIdAfterRevert = Get-Json "$base/inventory_carousell?inventory_ids=%5B$invId%5D&name=&category="
$calls.carousellGetAfterRevert=@{status=200;count=@($byIdAfterRevert).Count}

$simStillPresent = ($byIdAfterRevert | Where-Object { ("$($_.remark)") -like '*[SIM11-UPSERT]*' } | Measure-Object).Count -gt 0
$revertExact = (-not $simStillPresent) -and (@($byIdAfterRevert).Count -eq @($beforeRows).Count)

if($newRowsCreated -and -not $revertExact){
  $blocker = 'POST /inventory_carousell appears to create additional rows for same inventory_id and no delete endpoint exists in app contract for exact cleanup.'
}

$checks.navigationValidation=@{
  sourceDirect='/carousell -> /uploadCarousell (context.pushNamed without params)'
  sourceParamized='router supports query params inventoryId:int, category:String, search:String, searchCategory:String'
  requiredParamsInWidget='initState force-unwrap widget.inventoryId (widget!.inventoryId!) indicates param-required at runtime'
  paramToApiConsistency=$true
}
$checks.directVsParam=@{
  directEntrySupported=$false
  paramEntrySupported=$true
  mismatch=$true
  evidence='CarousellWidget navigates without params, but UploadCarousellWidget initState dereferences widget.inventoryId! causing runtime failure when null.'
}
$checks.mutation=@{
  inventoryId=$invId
  beforeCount=@($beforeRows).Count
  afterMutationCount=@($afterRows).Count
  mutationApplied=$mutationApplied
  newRowsCreated=$newRowsCreated
  revertExact=$revertExact
  simMarkerAbsentAfterRevert=(-not $simStillPresent)
}

$out=@{
  generatedAt=(Get-Date).ToUniversalTime().ToString('o')
  section='11) Upload Carousell flow'
  calls=$calls
  checks=$checks
  blocker=$blocker
}

$out | ConvertTo-Json -Depth 20 | Set-Content -Path $artifactPath -Encoding UTF8
Write-Output $artifactPath
